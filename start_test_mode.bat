@echo off
setlocal
cd /d "%~dp0"
title NextToppers QR Print V1.5 TEST MODE
if not exist .venv\Scripts\python.exe (py -3 -m venv .venv 2>nul || python -m venv .venv)
call .venv\Scripts\activate.bat
if not exist .venv\deps_v150.ok (
  python -m pip install --disable-pip-version-check -r requirements.txt
  if errorlevel 1 goto :fail
  type nul > .venv\deps_v150.ok
)
set "APP_PORT=8765"
set "LAN_REQUIRED=1"
set "PRINT_BACKEND=mock"
for /f "usebackq delims=" %%I in (`powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0detect_lan_ip.ps1"`) do set "LAN_IP=%%I"
if not defined LAN_IP (echo No LAN IPv4 detected.& pause & exit /b 2)
set "PUBLIC_BASE_URL=http://%LAN_IP%:%APP_PORT%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ensure_lan_firewall.ps1" -Port %APP_PORT%
echo TEST MODE - no physical paper will print.
python -m uvicorn app.main:app --host 0.0.0.0 --port %APP_PORT% --no-access-log
exit /b 0
:fail
echo TEST MODE START FAILED.
pause
exit /b 1
