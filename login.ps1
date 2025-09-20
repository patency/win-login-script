# Paths
$sshConfig   = "$HOME\.ssh\config"
$defaultFile = "$HOME\.ssh\login_default.txt"

# Read ssh config hosts
if (!(Test-Path $sshConfig)) {
    Write-Host "Cannot find $sshConfig"
    exit 1
}

$hosts = @()
Get-Content $sshConfig | ForEach-Object {
    if ($_ -match "^\s*Host\s+(.+)$") {
        $hosts += $Matches[1]
    }
}

if ($hosts.Count -eq 0) {
    Write-Host "No Host entries found in $sshConfig"
    exit 1
}

function Show-Help {
    Write-Host "Usage:"
    Write-Host "  login                	-> login default (or first) server"
    Write-Host "  login -l, --list     	-> list servers (no login)"
    Write-Host "  login -i <n>, --index <n>  -> login server by index"
    Write-Host "  login -d <n>, --default <n> -> set default server by index"
    Write-Host "  login -r, --reset    	-> reset default server"
    Write-Host "  login <hostname>     	-> login by host name"
    Write-Host "  login -h, --help    	-> show this help"
}

# If no arguments, login default
if ($args.Count -eq 0) {
    $defaultIndex = 0
    if (Test-Path $defaultFile) {
        $defaultIndex = Get-Content $defaultFile | Select-Object -First 1
    }

    if ($defaultIndex -match '^\d+$' -and [int]$defaultIndex -lt $hosts.Count) {
        Write-Host "Logging into default server [$defaultIndex] $($hosts[$defaultIndex])..."
        ssh $hosts[$defaultIndex]
    } else {
        Write-Host "Default config invalid, logging into first server $($hosts[0])"
        ssh $hosts[0]
    }
}
elseif ($args[0] -in @("-l","--list")) {
    Write-Host "Available servers:"
    for ($i=0; $i -lt $hosts.Count; $i++) {
        Write-Host "[$i] $($hosts[$i])"
    }
}
elseif ($args[0] -in @("-i","--index")) {
    if ($args.Count -ge 2 -and $args[1] -match '^\d+$' -and [int]$args[1] -lt $hosts.Count) {
        $idx = [int]$args[1]
        Write-Host "Logging into server [$idx] $($hosts[$idx])..."
        ssh $hosts[$idx]
    } else {
        Write-Host "Usage: login -i <number>"
    }
}
elseif ($args[0] -in @("-d","--default")) {
    if ($args.Count -ge 2 -and $args[1] -match '^\d+$' -and [int]$args[1] -lt $hosts.Count) {
        Set-Content -Path $defaultFile -Value $args[1]
        Write-Host "Default server set to [$($args[1])] $($hosts[$args[1]])"
    } else {
        Write-Host "Usage: login -d <number>"
    }
}
elseif ($args[0] -in @("-r","--reset")) {
    if (Test-Path $defaultFile) { Remove-Item $defaultFile }
    Write-Host "Default server reset. Next 'login' will use first server."
}
elseif ($args[0] -in @("-h","--help")) {
    Show-Help
}
else {
    # Treat as hostname
    $hostName = $args[0]
    if ($hosts -contains $hostName) {
        Write-Host "Logging into host $hostName..."
        ssh $hostName
    } else {
        Write-Host "Unknown host: $hostName"
        Show-Help
    }
}
