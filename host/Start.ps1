Param(
    [parameter(mandatory=$true)][alias("d")][string]$Distro
)

# Project ROOT Directory
$ROOT_DIR = Resolve-Path "$(Split-path -parent $MyInvocation.MyCommand.Definition)\.."

# Prepare logs directory
New-Item "$ROOT_DIR\log" -ItemType Directory -Force | Out-Null 

# Run WSL
$logPath = "$ROOT_DIR\log\log_$(Get-Date -UFormat "%Y%m%d_%H%M%S").txt" 
wsl -d $Distro -u root -- /etc/rc.local 2>&1 | Out-File $logPath -Encoding utf8
