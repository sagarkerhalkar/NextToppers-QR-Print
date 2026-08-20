param([int]$Port = 8765)
$ErrorActionPreference = 'Stop'
$ruleName = "NextToppers QR Print LAN $Port"

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    $args = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -Port $Port"
    try {
        $p = Start-Process powershell.exe -Verb RunAs -ArgumentList $args -Wait -PassThru
        exit $p.ExitCode
    } catch {
        Write-Host "LAN firewall permission was not granted." -ForegroundColor Red
        exit 1
    }
}

$existing = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
if (-not $existing) {
    New-NetFirewallRule `
        -DisplayName $ruleName `
        -Direction Inbound `
        -Action Allow `
        -Protocol TCP `
        -LocalPort $Port `
        -RemoteAddress LocalSubnet `
        -Profile Any | Out-Null
}
Write-Host "Windows Firewall ready for local-subnet TCP port $Port." -ForegroundColor Green
exit 0
