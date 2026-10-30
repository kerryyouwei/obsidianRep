param(
  [Parameter(ValueFromRemainingArguments=$true)]
  [string[]]$Links
)

$ErrorActionPreference = "Stop"

# ===== 可配置项 =====
$WhisperModel = "small"
$WhisperLanguage = "auto"
# YouTube 遇到风控时可改成 @("--cookies-from-browser", "edge")
$YtDlpCookiesArgs = @()
$OutputDir = Join-Path $PSScriptRoot "原始资料 raw"

function Write-Step([string]$Text) {
  Write-Host ""
  Write-Host "=== $Text ===" -ForegroundColor Cyan
}

function Write-Info([string]$Text) {
  Write-Host $Text -ForegroundColor DarkGray
}

function Write-WarnText([string]$Text) {
  Write-Host $Text -ForegroundColor Yellow
}

function Format-Seconds([object]$Seconds) {
  if ($null -eq $Seconds) { return "未知" }
  try { $Seconds = [double]$Seconds } catch { return "未知" }
  if ($Seconds -lt 0) { return "未知" }
  $total = [int][math]::Floor($Seconds)
  $hours = [int][math]::Floor($total / 3600)
  $minutes = [int][math]::Floor(($total % 3600) / 60)
  $seconds = [int]($total % 60)
  if ($hours -gt 0) {
    return "{0:D2}:{1:D2}:{2:D2}" -f $hours, $minutes, $seconds
  }
  return "{0:D2}:{1:D2}" -f $minutes, $seconds
}

function Get-SafeFileName([string]$Text) {
  $invalid = [IO.Path]::GetInvalidFileNameChars()
  $pattern = "[" + [Regex]::Escape(-join $invalid) + "]"
  $result = ($Text -replace $pattern, "_")
  $result = $result.Trim(" ", ".")
  if ($result.Length -gt 80) {
    $result = $result.Substring(0, 80).Trim(" ", ".")
  }
  return $result
}

function Test-PythonModule([string]$ModuleName) {
  $output = & $PythonExe -c "import importlib.util as u; print('OK' if u.find_spec('$ModuleName') else 'MISSING')" 2>$null
  return (($output | Select-Object -Last 1) -eq "OK")
}

# ===== 检查环境 =====

if (-not (Test-Path -LiteralPath $OutputDir -PathType Container)) {
  throw "输出目录不存在：$OutputDir"
}

$pythonCommand = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCommand) {
  throw "未找到 Python，请先安装 Python 3 并加入 PATH。"
}
$PythonExe = $pythonCommand.Source

if (-not (Test-PythonModule "yt_dlp")) {
  Write-Host "未找到 yt-dlp，正在自动安装..." -ForegroundColor Yellow
  & $PythonExe -m pip install yt-dlp
  if ($LASTEXITCODE -ne 0) { throw "yt-dlp 安装失败，请检查网络后重试。" }
  if (-not (Test-PythonModule "yt_dlp")) { throw "yt-dlp 安装后仍不可用。" }
}

if (-not (Test-PythonModule "faster_whisper")) {
  throw "未找到 faster-whisper，请先安装：python -m pip install faster-whisper"
}

# ===== 读取链接 =====

if (-not $Links) {
  $inputText = Read-Host "请粘贴 YouTube 链接（多个链接可用空格分隔）"
  $Links = @($inputText -split "\s+" | Where-Object { $_ })
}
if (-not $Links) {
  throw "没有输入任何链接。"
}

$success = @()
$failed = @()

foreach ($Url in $Links) {
  $workDir = $null
  try {
    Write-Step "处理：$Url"

    $workDir = Join-Path ([IO.Path]::GetTempPath()) ("yt-to-obsidian-" + [Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $workDir | Out-Null

    Write-Info "正在下载音频..."
    $audioBase = Join-Path $workDir "%(id)s"
    & $PythonExe -m yt_dlp --no-playlist --no-warnings --no-progress --write-info-json -f "bestaudio/best" -o "$audioBase.%(ext)s" @YtDlpCookiesArgs -- $Url
    if ($LASTEXITCODE -ne 0) {
      throw "yt-dlp 下载失败。"
    }

    $files = @(Get-ChildItem -LiteralPath $workDir -File)
    $jsonFile = $files | Where-Object { $_.Extension -eq ".json" } | Select-Object -First 1
    $mediaFile = $files | Where-Object { $_.Extension -ne ".json" } | Sort-Object Length -Descending | Select-Object -First 1

    if (-not $jsonFile -or -not $mediaFile) {
      throw "下载结果缺少音频文件或元数据文件。"
    }

    $info = [System.IO.File]::ReadAllText($jsonFile.FullName) | ConvertFrom-Json

    $TitleText = if ($info.title) { [string]$info.title } else { [string]$info.id }
    $VideoId = if ($info.id) { [string]$info.id } else { "unknown" }
    $SourceUrl = if ($info.webpage_url) { [string]$info.webpage_url } else { [string]$Url }
    $uploadDate = "未知"
    if ($info.upload_date -and [string]$info.upload_date -match "^\d{8}$") {
      $d = [string]$info.upload_date
      $uploadDate = "$($d.Substring(0,4))-$($d.Substring(4,2))-$($d.Substring(6,2))"
    }
    $channelText = if ($info.uploader) { [string]$info.uploader } elseif ($info.channel) { [string]$info.channel } else { "未知" }

    Write-Info "正在用 Whisper（$WhisperModel）本地转录，长视频需要较长时间..."

    $pyPath = Join-Path $workDir "transcribe.py"
    $transcriptJson = Join-Path $workDir "transcript.json"
    $pyLines = @(
      "import argparse, json",
      "from faster_whisper import WhisperModel",
      "parser = argparse.ArgumentParser()",
      "parser.add_argument('--audio')",
      "parser.add_argument('--model')",
      "parser.add_argument('--language')",
      "parser.add_argument('--output')",
      "args = parser.parse_args()",
      "model = WhisperModel(args.model, device='cpu', compute_type='int8')",
      "segments, info = model.transcribe(args.audio, language=None if args.language in ('auto', '', 'None') else args.language, vad_filter=True, vad_parameters={'min_silence_duration_ms': 500})",
      "items = []",
      "for seg in segments:",
      "    items.append({'start': seg.start, 'end': seg.end, 'text': (seg.text or '').strip()})",
      "result = {'language': info.language, 'segments': items}",
      "with open(args.output, 'w', encoding='utf-8-sig') as f:",
      "    json.dump(result, f, ensure_ascii=False)"
    )
    Set-Content -LiteralPath $pyPath -Value $pyLines -Encoding UTF8

    & $PythonExe $pyPath --audio $mediaFile.FullName --model $WhisperModel --language $WhisperLanguage --output $transcriptJson
    if ($LASTEXITCODE -ne 0) {
      throw "Whisper 转录失败。"
    }

    $transcript = [System.IO.File]::ReadAllText($transcriptJson) | ConvertFrom-Json
    $languageText = if ($transcript.language) { [string]$transcript.language } else { "自动检测" }

    $transcriptLines = @()
    foreach ($seg in $transcript.segments) {
      $segText = ([string]($seg.text) -replace "\s+", " ").Trim()
      if ($segText) {
        $transcriptLines += ("[{0}] {1}" -f (Format-Seconds $seg.start), $segText)
      }
    }
    $transcriptText = if ($transcriptLines) { $transcriptLines -join [Environment]::NewLine } else { "" }

    $safeTitle = Get-SafeFileName $TitleText
    if (-not $safeTitle) { $safeTitle = $VideoId }

    $yamlTitle = "'" + ($TitleText -replace "'", "''") + "'"

    $markdown = @"
---
来源: $SourceUrl
视频ID: $VideoId
标题: $yamlTitle
上传日期: $uploadDate
转录日期: $(Get-Date -Format "yyyy-MM-dd")
转录模型: $WhisperModel
---

# $TitleText

## 元数据

- 来源链接：[$SourceUrl]($SourceUrl)
- 视频ID：$VideoId
- 上传日期：$uploadDate
- 时长：$(Format-Seconds $info.duration)
- 转录模型：$WhisperModel
- 语言：$languageText
- 频道：$channelText

## 转录

$transcriptText
"@

    $outPath = Join-Path $OutputDir ($safeTitle + ".md")
    if (Test-Path -LiteralPath $outPath) {
      $outPath = Join-Path $OutputDir ($safeTitle + " - " + $VideoId + ".md")
    }
    if (Test-Path -LiteralPath $outPath) {
      $outPath = Join-Path $OutputDir ($safeTitle + " - " + $VideoId + " - " + (Get-Date -Format "yyyyMMdd-HHmmss") + ".md")
    }

    Set-Content -LiteralPath $outPath -Value $markdown -Encoding UTF8
    $success += [pscustomobject]@{ Url = $Url; Path = $outPath }
    Write-Host "已保存：$outPath" -ForegroundColor Green
  }
  catch {
    $failed += [pscustomobject]@{ Url = $Url; Error = $_.Exception.Message }
    Write-WarnText "处理失败：$Url"
    Write-WarnText $_.Exception.Message
  }
  finally {
    if ($workDir -and (Test-Path -LiteralPath $workDir)) {
      Remove-Item -LiteralPath $workDir -Recurse -Force -ErrorAction SilentlyContinue
    }
  }
}

Write-Step "处理完成"
if ($success) {
  Write-Host "成功 $($success.Count) 个：" -ForegroundColor Green
  foreach ($item in $success) {
    Write-Host "  $($item.Path)" -ForegroundColor Green
  }
}
if ($failed) {
  Write-Host "失败 $($failed.Count) 个：" -ForegroundColor Red
  foreach ($item in $failed) {
    Write-Host "  $($item.Url) -> $($item.Error)" -ForegroundColor Red
  }
}
