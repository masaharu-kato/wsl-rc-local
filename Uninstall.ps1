Param(
    [string]$TaskNameBase = "Start-WSL-RC-Local",
    [parameter(mandatory=$true)][string]$Distro="",
    [string]$UserName = $env:UserName
)

$global:ErrorActionPreference = 'Stop'
try {
    # Task name
    $TaskName = "${TaskNameBase}(user=${UserName},distro=${Distro})"

    # Unregister
    Unregister-ScheduledTask -TaskName "$TaskName" -Confirm:$false

    Write-Host "Successfully Uninstalled." -ForegroundColor Green

} catch {
    Write-Host "Failed to install." -ForegroundColor Red
    Write-Host $_ -ForegroundColor Magenta
}
