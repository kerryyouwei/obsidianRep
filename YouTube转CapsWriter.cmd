@echo off
setlocal
chcp 65001 >nul
title YouTube to CapsWriter
cd /d "%~dp0"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0YouTube转CapsWriter.ps1" "%~1"
set "EXITCODE=%ERRORLEVEL%"

echo.
if not "%EXITCODE%"=="0" (
    echo Script failed with exit code: %EXITCODE%.
) else (
    echo Done.
)

pause
exit /b %EXITCODE%