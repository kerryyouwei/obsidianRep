@echo off
cd /d "%~dp0"
for %%f in ("%~dp0YouTube*.ps1") do (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%%f"
  goto :done
)
:done
pause
