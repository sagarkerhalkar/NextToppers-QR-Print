@echo off
setlocal
cd /d "%~dp0"
title NextToppers QR Print V1.5

echo [1/5] Preparing Python environment...
if not exist .venv\Scripts\python.exe (
  py -3 -m venv .venv 2>nul || python -m venv .venv
  if errorlevel 1 goto :fail
)
call .venv\Scripts\activate.bat

rem Install dependencies only once for this release, not on every startup.
if not exist .venv\deps_v150.ok (
  echo [2/5] Installing/updating app dependencies once...
  python -m pip install --disable-pip-version-check -r requirements.txt
  if errorlevel 1 goto :fail
  type nul > .venv\deps_v150.ok
) else (
  echo [2/5] Dependencies ready - skipped package install.
)

set "APP_PORT=8765"
set "LAN_REQUIRED=1"
set "PRINT_BACKEND=sumatra"
if "%ADMIN_USERNAME%"=="" set "ADMIN_USERNAME=admin"
if "%ADMIN_PASSWORD%"=="" set "ADMIN_PASSWORD=ChangeMe123!"

echo [3/5] Detecting local-network address...
for /f "usebackq delims=" %%I in (`powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0detect_lan_ip.ps1"`) do set "LAN_IP=%%I"
if not defined LAN_IP (echo ERROR: No usable LAN IPv4 detected.& pause & exit /b 2)
set "PUBLIC_BASE_URL=http://%LAN_IP%:%APP_PORT%"

echo [4/5] Checking local firewall and print engine...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ensure_lan_firewall.ps1" -Port %APP_PORT%
if errorlevel 1 (echo ERROR: Firewall setup failed. Run this BAT as Administrator.& pause & exit /b 3)
for /f "usebackq delims=" %%S in (`powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ensure_print_engine.ps1"`) do set "SUMATRA_PATH=%%S"
if not exist "%SUMATRA_PATH%" (echo ERROR: SumatraPDF print engine not available.& pause & exit /b 5)

echo [5/5] Starting NextToppers QR Print...
echo.
echo ============================================================
echo NextToppers QR Print V1.5 - GLOBAL UI / REAL LAN PRINTING
echo Customer: %PUBLIC_BASE_URL%/
echo Admin   : %PUBLIC_BASE_URL%/admin
echo Printer : Admin-selected Windows printer
echo Drive   : Google OAuth + Drive-only document storage
echo ============================================================
start "NextToppers QR Print Admin" "%PUBLIC_BASE_URL%/admin"
python -m uvicorn app.main:app --host 0.0.0.0 --port %APP_PORT% --no-access-log
if errorlevel 1 goto :fail
exit /b 0

:fail
echo.
echo APP START FAILED. See the error above.
pause
exit /b 1
