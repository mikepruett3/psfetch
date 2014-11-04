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

param (
    [string]$Path
)

if ( $psboundparameters.Count -eq 0 ) {
    Write-Host "Not taking screenshot, just displaying information..."
    Write-Host ""
}

if ( $Path -And !( Test-Path -path $Path) ) {
    Write-Host "Path cannot be found..."
    Write-Host ""
    break
}

# DONE: Function to Take the Screenshot
Function Take-Screenshot {
    [CmdletBinding()]
        Param(
            [string]$Width,
            [string]$Height,
            [string]$TarPath
        )

    PROCESS {
        [Reflection.Assembly]::LoadWithPartialName("System.Drawing") > $Null
        $bounds = [Drawing.Rectangle]::FromLTRB(0, 0, $Width, $Height )

        # Check Path for Trailing BackSlashes
        if ( $TarPath.EndsWith("\") ) {
            $TarPath = $TarPath.Substring(0,$Path.Length-1)
        }

        # Define The Target Path
        $stamp = get-date -f MM-dd-yyyy_HH_mm_ss
        $target = "$TarPath\screenshot-$stamp.png"

        # Take the Screenshot
        $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
        $graphics = [Drawing.Graphics]::FromImage($bmp)
        $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
        $bmp.Save($target)
        $graphics.Dispose()
        $bmp.Dispose()
    }
}

$USERNAME = [Environment]::USERNAME
$WORKSTATION = $Env:COMPUTERNAME
$OS = (Get-WmiObject -class Win32_OperatingSystem).Caption
$ARCH = (Get-WmiObject -class Win32_OperatingSystem).osarchitecture
$CPU = [Decimal]::Round((Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue)

# TODO: Re-Write this to support multiple Hard Drives
#$HDD = [Decimal]::Round((Get-Counter '\LogicalDisk(C:)\Free Megabytes').CounterSamples.CookedValue / 1024)
Get-WmiObject Win32_LogicalDisk | ? {$_.DriveType -eq 3} | Select-Object DeviceID |
ForEach ($_.DeviceID ) {
    $DriveLetter = ($_.DeviceID).Replace(":","")
    $DriveFreeSpace = [Decimal]::Round((Get-Counter '\LogicalDisk(C:)\Free Megabytes').CounterSamples.CookedValue / 1024)
    #Write-Host "Drive $DriveLetter has $DriveFreeSpace GB Free Space"
}

$MEMTOTAL = [Decimal]::Round(((Get-WmiObject -class Win32_OperatingSystem).TotalVisibleMemorySize / 1024))
$MEMFREE = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
$MEM = "$MEMFREE MB out of $MEMTOTAL MB available"

$UPTIME = (Get-CimInstance -ClassName win32_operatingsystem).LastBootuptime 

# TODO: Fix support for Multiple Monitors
$ScreenWidth = (Get-WmiObject -Class Win32_DesktopMonitor).ScreenWidth
$ScreenHeight = (Get-WmiObject -Class Win32_DesktopMonitor).ScreenHeight
$RESOLUTION = "$ScreenWidth x $ScreenHeight"

# Clear Screen before displaying information
Clear-Host

# DONE: Add Countdown Timer
Write-Host "...3" -nonewline;
Start-Sleep -s 1
Write-Host "...2" -nonewline;
Start-Sleep -s 1
Write-Host "...1" -nonewline;
Start-Sleep -m 500
Write-Host "    Cheese!"

# Write-Host all of the collected information, including a Windows Logo in Ansi
Write-Host "`n"
Write-Host '        ,.=:!!t3Z3z.,               ' -foregroundcolor "red"

Write-Host '       :tt:::tt333EE3               ' -foregroundcolor "red" -nonewline;
Write-Host "    $USERNAME" -foregroundcolor "red" -nonewline;
Write-Host "@" -foregroundcolor "white" -nonewline;
Write-Host "$WORKSTATION" -foregroundcolor "yellow"

Write-Host '       Et:::ztt33EEEL ' -foregroundcolor "red" -nonewline;
Write-Host '@Ee.,      ..,' -foregroundcolor "green"

Write-Host '      ;tt:::tt333EE7 ' -foregroundcolor "red" -nonewline;
Write-Host ';EEEEEEttttt33#' -foregroundcolor "green" -nonewline;
Write-Host "    OS: " -foregroundcolor "red" -nonewline;
Write-Host "$OS $ARCH" -foregroundcolor "white"

Write-Host '     :Et:::zt333EEQ. ' -foregroundcolor "red" -nonewline;
Write-Host '$EEEEEttttt33QL' -foregroundcolor "green" -nonewline;
Write-Host "    CPU: " -foregroundcolor "red" -nonewline;
Write-Host "$CPU% utilization" -foregroundcolor "white"

Write-Host '     it::::tt333EEF ' -foregroundcolor "red" -nonewline;
Write-Host '@EEEEEEttttt33F ' -foregroundcolor "green" -nonewline;
Write-Host "    Memory: " -foregroundcolor "red" -nonewline;
Write-Host "$MEM" -foregroundcolor "white"

Write-Host '    ;3=*^```"*4EEV ' -foregroundcolor "red" -nonewline;
Write-Host ':EEEEEEttttt33@. ' -foregroundcolor "green" -nonewline;
Write-Host "    Uptime: " -foregroundcolor "red" -nonewline;
Write-Host "$UPTIME" -foregroundcolor "white"

Write-Host '    ,.=::::!t=., ' -foregroundcolor "blue" -nonewline;
Write-Host '` ' -foregroundcolor "red" -nonewline;
Write-Host '@EEEEEEtttz33QF  ' -foregroundcolor "green" -nonewline;
Write-Host "    Resolution: " -foregroundcolor "red" -nonewline;
Write-Host "$RESOLUTION" -foregroundcolor "white"

Write-Host '   ;::::::::zt33)   ' -foregroundcolor "blue" -nonewline;
Write-Host '"4EEEtttji3P*   ' -foregroundcolor "green"

Write-Host '  :t::::::::tt33.' -foregroundcolor "blue" -nonewline;
Write-Host ' :Z3z.. `` ,..g.   ' -foregroundcolor "yellow" -nonewline;

# TODO: Need to Re-Write this to loop thru multiple drives (without screwing up the Windows Logo!)
Write-Host "    HDD: " -foregroundcolor "red" -nonewline;
Write-Host "$DriveLetter`:`\ has $DriveFreeSpace GB Free Space" -foregroundcolor "white"

Write-Host '  i::::::::zt33F ' -foregroundcolor "blue" -nonewline;
Write-Host 'AEEEtttt::::ztF    ' -foregroundcolor "yellow"

Write-Host ' ;:::::::::t33V ' -foregroundcolor "blue" -nonewline;
Write-Host ';EEEttttt::::t3     ' -foregroundcolor "yellow"

Write-Host ' E::::::::zt33L ' -foregroundcolor "blue" -nonewline;
Write-Host '@EEEtttt::::z3F     ' -foregroundcolor "yellow"

Write-Host '{3=*^```"*4E3) ' -foregroundcolor "blue" -nonewline;
Write-Host ';EEEtttt:::::tZ`     ' -foregroundcolor "yellow"

Write-Host '             ` ' -foregroundcolor "blue" -nonewline;
Write-Host ':EEEEtttt::::z7      ' -foregroundcolor "yellow"

Write-Host '                 ' -foregroundcolor "blue" -nonewline;
Write-Host '"VEzjt:;;z>*`      ' -foregroundcolor "yellow"

Write-Host "`n"

# Take Screenshot if the Parameters are assigned...
if ( $Path ) {
    Take-Screenshot -Width $ScreenWidth -Height $ScreenHeight -TarPath $Path
}

