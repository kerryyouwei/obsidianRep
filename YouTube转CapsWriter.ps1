param(
    [Parameter(Position = 0)]
    [string]$Url = ""
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RawDir    = Join-Path $ScriptDir "原始资料 raw"
$YtDlpLocal = Join-Path $ScriptDir "yt-dlp.exe"
$YtDlpUrl   = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"

# 如需 YouTube 风控跳过登录，可改成 @("--cookies-from-browser", "edge")
$YtDlpCookiesArgs = @()

# 质量优先：优先下载最高码率的 m4a/AAC 音轨（通常约 128kbps）；没有 m4a 时退回 webm/Opus；最后退回任意最佳音轨
$YtDlpFormat = "ba[ext=m4a]/ba[ext=webm]/ba"

$CapsClient = "E:\360Downloads\CapsWriter-Offline-master\dist\CapsWriter-Offline\start_client.exe"
$CapsDir = Split-Path -Parent $CapsClient
$CapsServer = Join-Path $CapsDir "start_server.exe"

function Write-Step([string]$Text) {
    Write-Host ""
    Write-Host "=== $Text ===" -ForegroundColor Cyan
}

function Write-Info([string]$Text) {
    Write-Host $Text -ForegroundColor DarkGray
}

function Write-Warn([string]$Text) {
    Write-Host $Text -ForegroundColor Yellow
}

function Get-YtDlp {
    if (Test-Path -LiteralPath $YtDlpLocal -PathType Leaf) {
        return $YtDlpLocal
    }

    $found = Get-Command "yt-dlp.exe" -ErrorAction SilentlyContinue
    if ($found) {
        return $found.Source
    }

    Write-Info "未找到 yt-dlp，正在下载 yt-dlp.exe 到脚本目录..."
    $tmp = "$YtDlpLocal.tmp"
    & curl.exe -L --fail --silent --show-error -o $tmp $YtDlpUrl
    if ($LASTEXITCODE -ne 0) {
        throw "yt-dlp 下载失败。请手动下载 $YtDlpUrl 并放到：$YtDlpLocal"
    }
    Move-Item -LiteralPath $tmp -Destination $YtDlpLocal -Force
    if (-not (Test-Path -LiteralPath $YtDlpLocal -PathType Leaf)) {
        throw "yt-dlp.exe 下载后未找到：$YtDlpLocal"
    }
    return $YtDlpLocal
}

function Wait-CapsServer {
    param([int]$TimeoutSeconds = 30)

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        $client = New-Object System.Net.Sockets.TcpClient
        try {
            $iar = $client.BeginConnect("127.0.0.1", 6016, $null, $null)
            if ($iar.AsyncWaitHandle.WaitOne(500)) {
                $client.EndConnect($iar)
                $client.Close()
                return
            }
        } catch {
            # 端口未就绪，继续等待
        } finally {
            $client.Close()
        }
        Start-Sleep -Milliseconds 500
    }

    throw "CapsWriter 服务端（127.0.0.1:6016）未就绪，请先启动 start_server.exe。"
}

function Remove-MdTimestampSection {
    param([string]$Path)

    $text = [System.IO.File]::ReadAllText($Path)
    $lines = $text -split "\r?\n"
    $kept = New-Object System.Collections.Generic.List[string]

    foreach ($line in $lines) {
        if ($line.Trim() -eq "## 时间戳索引") {
            break
        }
        $kept.Add($line)
    }

    $cleaned = ($kept -join [Environment]::NewLine).TrimEnd() + [Environment]::NewLine
    [System.IO.File]::WriteAllText($Path, $cleaned, (New-Object System.Text.UTF8Encoding($false)))
}

try {
    Write-Step "检查环境"

    if (-not (Test-Path -LiteralPath $RawDir -PathType Container)) {
        throw "输出目录不存在：$RawDir"
    }
    if (-not (Test-Path -LiteralPath $CapsClient -PathType Leaf)) {
        throw "未找到 CapsWriter 客户端：$CapsClient"
    }

    $ytdlp = Get-YtDlp

    if ([string]::IsNullOrWhiteSpace($Url)) {
        $Url = Read-Host "请输入 YouTube 视频网址"
    }
    $Url = $Url.Trim()
    $Url = $Url.Trim('"')
    if ([string]::IsNullOrWhiteSpace($Url)) {
        throw "没有输入 YouTube 网址。"
    }

    if (-not (Get-Process -Name "start_server" -ErrorAction SilentlyContinue)) {
        Write-Info "未发现 CapsWriter 服务端，正在自动启动 start_server.exe..."
        Start-Process -FilePath $CapsServer -WorkingDirectory $CapsDir -WindowStyle Hidden
    } else {
        Write-Info "检测到 CapsWriter 服务端已在运行。"
    }
    Wait-CapsServer
    Write-Info "CapsWriter 服务端已就绪。"

    # ===== 1. 用 yt-dlp 下载最小的纯音频文件到 raw =====
    Write-Step "下载音频"
    Write-Info "网页地址：$Url"
    Write-Info "保存目录：$RawDir"

    $pathFile = Join-Path $env:TEMP ("ytdlp_path_" + [guid]::NewGuid().ToString("N") + ".txt")
    try {
        $outTemplate = Join-Path $RawDir ("%(title).80s [%(id)s].%(ext)s")
        $dlArgs = @(
            "--no-playlist",
            "--no-progress",
            "--no-warnings",
            "-f", $YtDlpFormat,
            "--print-to-file", "after_move:filepath", $pathFile,
            "-o", $outTemplate
        )
        $dlArgs += $YtDlpCookiesArgs
        $dlArgs += @("--", $Url)

        & $ytdlp @dlArgs
        if ($LASTEXITCODE -ne 0) {
            throw "yt-dlp 下载失败。"
        }

        if (-not (Test-Path -LiteralPath $pathFile -PathType Leaf)) {
            throw "未能从 yt-dlp 获取下载后的文件路径。"
        }

        $audioPath = @(Get-Content -LiteralPath $pathFile -Encoding UTF8 | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" } | Select-Object -First 1)
        if (-not $audioPath) {
            throw "下载路径文件为空。"
        }
        $audioPath = [string]$audioPath
    } finally {
        if (Test-Path -LiteralPath $pathFile -PathType Leaf) {
            Remove-Item -LiteralPath $pathFile -Force
        }
    }

    if (-not (Test-Path -LiteralPath $audioPath -PathType Leaf)) {
        throw "找不到下载后的音频文件：$audioPath"
    }
    $audioPath = (Resolve-Path -LiteralPath $audioPath).Path
    Write-Info "音频文件：$audioPath"

    # ===== 2. 调用 CapsWriter start_client.exe 转录 =====
    Write-Step "CapsWriter 转录"

    Write-Info "正在转录，下面显示 CapsWriter 实时进度..."
    $cmdline = 'echo.|"' + $CapsClient + '" "' + $audioPath + '"'
    & cmd.exe /c $cmdline
    $capsExitCode = $LASTEXITCODE
    if ($capsExitCode -ne 0) {
        Write-Warn "CapsWriter 返回退出码 $capsExitCode。"
    }
    Write-Info "转录结束。"
    # ===== 3. 把生成的 .md 放到 raw，并删除“## 时间戳索引”段落 =====
    Write-Step "整理 Markdown"

    $generatedMd = [System.IO.Path]::ChangeExtension($audioPath, ".md")
    if (-not (Test-Path -LiteralPath $generatedMd -PathType Leaf)) {
        throw "CapsWriter 没有生成 Markdown：$generatedMd"
    }

    Remove-MdTimestampSection -Path $generatedMd

    $generatedFull = (Resolve-Path -LiteralPath $generatedMd).Path
    $rawPrefix = [System.IO.Path]::GetFullPath($RawDir).TrimEnd("\") + "\"
    if ($generatedFull.StartsWith($rawPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        $finalMd = $generatedFull
        Write-Info "Markdown 已位于 raw，无需移动。"
    } else {
        $destMd = Join-Path $RawDir ([System.IO.Path]::GetFileName($generatedFull))
        if (Test-Path -LiteralPath $destMd -PathType Leaf) {
            $base = [System.IO.Path]::GetFileNameWithoutExtension($generatedFull)
            $destMd = Join-Path $RawDir ($base + " - " + (Get-Date -Format "yyyyMMdd-HHmmss") + ".md")
        }
        Move-Item -LiteralPath $generatedFull -Destination $destMd
        $finalMd = $destMd
        Write-Info "已移动 Markdown。"
    }

    # 删除 CapsWriter 生成的副产物，只保留 .md 和原始音频
    foreach ($ext in @(".txt", ".json", ".srt", ".merge.txt")) {
        $sidecar = [System.IO.Path]::ChangeExtension($audioPath, $ext)
        if (Test-Path -LiteralPath $sidecar -PathType Leaf) {
            Remove-Item -LiteralPath $sidecar -Force -ErrorAction SilentlyContinue
        }
    }

    Write-Step "完成"
    Write-Host "音频文件：$audioPath" -ForegroundColor Green
    Write-Host "转录笔记：$finalMd" -ForegroundColor Green
    Write-Host "已移除“## 时间戳索引”段落。" -ForegroundColor Green
} catch {
    Write-Warn $_.Exception.Message
    exit 1
}
