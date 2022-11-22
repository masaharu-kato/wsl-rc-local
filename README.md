# WSL-RC-Local

Enable Linux `/etc/rc.local` (Script run at startup) on WSL (Windows Subsystem for Linux)

## Installation

Run `.\Install.ps1 -d Ubuntu` on PowerShell on Windows.

* Replace `Ubuntu` to the WSL distribution name to set
* To run script when the host machine startups (not on user signined), use `-noLogon` option and run with administrator.
(Credential input needed.)
* You can set the startup settings by multiple distributions or host (windows) users.

## How to use

1. Install following the above
2. Create a file `/etc/rc.local` on the WSL if not exists
3. Write the scripts to execute when WSL startups (The script runs with `root` user)
4. Set the root execution permission to the file
5. To apply startup, Sign-out and Sign-in on the host (Windows).  
If you installed with `-noLogon` option, Reboot the host (Windows) machine.  
(NOT shutdown and boot, but Reboot)


## Uninstallation

Run `.\Install.ps1 -d Ubuntu` on PowerShell on Windows.

* Replace `Ubuntu` to the WSL distribution name to unset
