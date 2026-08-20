$ErrorActionPreference = 'Stop'
$paths=@("C:\Program Files\SumatraPDF\SumatraPDF.exe","C:\Program Files (x86)\SumatraPDF\SumatraPDF.exe","$env:LOCALAPPDATA\SumatraPDF\SumatraPDF.exe")
foreach($p in $paths){if(Test-Path $p){Write-Output $p; exit 0}}
Write-Host "SumatraPDF is required for reliable unattended PDF printing." -ForegroundColor Yellow
if(Get-Command winget -ErrorAction SilentlyContinue){
  Write-Host "Installing SumatraPDF with winget..."
  winget install --id SumatraPDF.SumatraPDF -e --silent --accept-package-agreements --accept-source-agreements
  Start-Sleep -Seconds 2
  foreach($p in $paths){if(Test-Path $p){Write-Output $p; exit 0}}
}
Write-Host "Automatic install failed. Install SumatraPDF and run this launcher again." -ForegroundColor Red
exit 5
