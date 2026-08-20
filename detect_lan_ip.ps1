$ErrorActionPreference = 'SilentlyContinue'
$ip = Get-NetIPConfiguration |
    Where-Object { $_.NetAdapter.Status -eq 'Up' -and $_.IPv4Address -and $_.IPv4DefaultGateway } |
    ForEach-Object { $_.IPv4Address.IPAddress } |
    Where-Object { $_ -notmatch '^(127\.|169\.254\.)' } |
    Select-Object -First 1

if (-not $ip) {
    $ip = Get-NetIPAddress -AddressFamily IPv4 |
        Where-Object { $_.IPAddress -notmatch '^(127\.|169\.254\.)' -and $_.AddressState -eq 'Preferred' } |
        Select-Object -ExpandProperty IPAddress -First 1
}

if ($ip) {
    Write-Output $ip
    exit 0
}
exit 1
