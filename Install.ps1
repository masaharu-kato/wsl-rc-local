Param(
    [string]$TaskNameBase = "Start-WSL-RC-Local",
    [parameter(mandatory=$true)][alias("d")][string]$Distro,
    [switch]$noLogon
)

$global:ErrorActionPreference = 'Stop'
try {
    $ROOT_DIR = Resolve-Path "$(Split-path -parent $MyInvocation.MyCommand.Definition)"

    # Check a given distro
    $res = wsl -d $Distro -- :
    if($res) { throw "WSL Distribution '$Distro' not exists." }

    # Get username (and password)
    if($noLogon) {
        $Credentials = Get-Credential
        $NetCred = $Credentials.GetNetworkCredential()
        $UserName = $NetCred.UserName
    } else {
        $UserName = $env:UserName
    }

    # Task name
    $TaskName = "${TaskNameBase}(user=${UserName},distro=${Distro})"
    Write-Host "Taskname: $TaskName"

    # Check the existing task
    if(Get-ScheduledTask -TaskName $TaskName -ErrorAction Ignore) {
        Write-Host "Notice: Scheduled Task '$TaskName' already exists"
    }

    # Trigger: Run when the target user (which has the WSL) logined
    if($noLogon) {
        $Trigger = New-ScheduledTaskTrigger -AtStartup
    }else{
        $Trigger = New-ScheduledTaskTrigger -AtLogOn -User $UserName
    }

    # Action: Run WSL-PFM host script
    $scriptPath = "$ROOT_DIR\host\Start.ps1"
    $Action = New-ScheduledTaskAction -Execute powershell -Argument "-ExecutionPolicy RemoteSigned -File `"$scriptPath`" $Distro"

    # Task settings
    $TaskSet = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -Hidden

    # Register
    if($noLogon) {
        Register-ScheduledTask -TaskName "$TaskName" -Action $Action -Trigger $Trigger -Settings $TaskSet -User $UserName -Password $($NetCred.Password) -Force | Out-Null
    } else {
        Register-ScheduledTask -TaskName "$TaskName" -Action $Action -Trigger $Trigger -Settings $TaskSet -Force | Out-Null
    }

    Write-Host "Successfully installed as a Scheduled Task '$TaskName'" -ForegroundColor Green

} catch {
    Write-Host "Failed to Install." -ForegroundColor Red
    Write-Host $_ -ForegroundColor Magenta
}
