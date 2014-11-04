# PSFetch.ps1
# A Screenfetch writen in PowerShell
#
# Like https://github.com/Nijikokun/WinScreeny, only no LUA requirement
#
# -----------------------------------------------------------
# The Original Inspirations for CMDfetch:
# -----------------------------------------------------------
# screenFetch by KittyKatt
#   https://github.com/KittyKatt/screenFetch
#   A very nice screenshotting and information tool. For GNU/Linux (Almost all Major Distros Supported) *This has been ported to Windows, link below.*
#
# archey by djmelik
#   https://github.com/djmelik/archey
#   Another nice screenshotting and information tool. More hardware oriented than screenFetch. For GNU/Linux
# -----------------------------------------------------------
#

$OS = (Get-WmiObject -class Win32_OperatingSystem).Caption
$ARCH = (Get-WmiObject -class Win32_OperatingSystem).osarchitecture
$CPU = [Decimal]::Round((Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue)

#$HDDC = [Decimal]::Round((Get-Counter '\LogicalDisk(C:)\Free Megabytes').CounterSamples.CookedValue / 1024)
Get-WmiObject Win32_LogicalDisk | ? {$_.DriveType -eq 3} | Select-Object DeviceID |
ForEach ($_.DeviceID ) {
    $DriveLetter = ($_.DeviceID).Replace(":","")
    $DriveFreeSpace = [Decimal]::Round((Get-Counter '\LogicalDisk(C:)\Free Megabytes').CounterSamples.CookedValue / 1024)
    Write-Host "Drive $DriveLetter has $DriveFreeSpace GB Free Space"
}

$MEMTOTAL = [Decimal]::Round(((Get-WmiObject -class Win32_OperatingSystem).TotalVisibleMemorySize / 1024))
$MEMFREE = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
$MEM = "$MEMFREE out of $MEMTOTAL available"

$UPTIME = (Get-CimInstance -ClassName win32_operatingsystem).LastBootuptime 

$ScreenWidth = (Get-WmiObject -Class Win32_DesktopMonitor).ScreenWidth
$ScreenHeight = (Get-WmiObject -Class Win32_DesktopMonitor).ScreenHeight
$RESOLUTION = "$ScreenWidth x $ScreenHeight"

#$SHELL
#$DE
#$FONT

Write-Host $OS
Write-Host $ARCH
Write-Host $CPU
Write-Host $MEM
Write-Host $UPTIME
Write-Host $RESOLUTION

