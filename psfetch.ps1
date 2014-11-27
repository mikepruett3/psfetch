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
        
		# Changed how $bounds is calculated so that screen shots with multiple monitors that are offset work correctly
		$bounds = [Windows.Forms.SystemInformation]::VirtualScreen
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


$driveSpecs = Get-WmiObject Win32_LogicalDisk | ? {$_.DriveType -eq 3} | 
	ForEach {
		New-Object -TypeName PSObject -Property @{
			DriveLetter = ($_.DeviceID).Replace(":","");
			DriveFreeSpace = [Decimal]::Round($_.FreeSpace / 1GB)
		}
	}

$MEMTOTAL = [Decimal]::Round(((Get-WmiObject -class Win32_OperatingSystem).TotalVisibleMemorySize / 1024))
$MEMFREE = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
$MEM = "$MEMFREE MB out of $MEMTOTAL MB available"

$UPTIME = (Get-CimInstance -ClassName win32_operatingsystem).LastBootuptime 

# DONE: Fix support for Multiple Monitors
# FROM: Shay Levy's Response - http://stackoverflow.com/questions/7967699/get-screen-resolution-using-wmi-powershell-in-windows-7
$ScreenWidth = 0
$ScreenHeight = 0
Add-Type -AssemblyName System.Windows.Forms
$DisplayCount = [System.Windows.Forms.Screen]::AllScreens.Bounds.Count
$Bounds = [System.Windows.Forms.Screen]::AllScreens | Select-Object -ExpandProperty Bounds

$ScreenWidth = $Bounds | Measure-Object -Property Width -Sum | Select-Object -ExpandProperty Sum
$ScreenHeight = $Bounds | Measure-Object -Property Height -Maximum | Select-Object -ExpandProperty Maximum

$RESOLUTION = "$ScreenWidth x $ScreenHeight"

# Clear Screen before displaying information
Clear-Host

# Only show the countdown if we're taking a screen shot
if ($Path) {
# DONE: Add Countdown Timer
	Write-Host "...3" -nonewline;
	Start-Sleep -s 1
	Write-Host "...2" -nonewline;
	Start-Sleep -s 1
	Write-Host "...1" -nonewline;
	Start-Sleep -m 500
	Write-Host "    Cheese!"
}


# Array of arrays of script blocks, containing commands to draw the Windows Logo.
# Each sub-array should correspond to 1 line of the logo
$Logo = @(
	@( 	{ Write-Host "`n" -nonewline } ),
	@( 	{ Write-Host '        ,.=:!!t3Z3z.,               ' -foregroundcolor "red" -nonewline } ),
	@( 	{ Write-Host '       :tt:::tt333EE3               ' -foregroundcolor "red" -nonewline } ),
	@(	{ Write-Host '       Et:::ztt33EEEL ' -foregroundcolor "red" -nonewline }, 
		{ Write-Host '@Ee.,      ..,' -foregroundcolor "green" -nonewline } ),
	@(	{ Write-Host '      ;tt:::tt333EE7 ' -foregroundcolor "red" -nonewline },
		{ Write-Host ';EEEEEEttttt33#' -foregroundcolor "green" -nonewline } ),
	@(  { Write-Host '     :Et:::zt333EEQ. ' -foregroundcolor "red" -nonewline },
		{ Write-Host '$EEEEEttttt33QL' -foregroundcolor "green" -nonewline } ),
	@(	{ Write-Host '     it::::tt333EEF ' -foregroundcolor "red" -nonewline },
		{ Write-Host '@EEEEEEttttt33F ' -foregroundcolor "green" -nonewline } ),
	@(	{ Write-Host '    ;3=*^```"*4EEV ' -foregroundcolor "red" -nonewline },
		{ Write-Host ':EEEEEEttttt33@. ' -foregroundcolor "green" -nonewline } ),
	@(	{ Write-Host '    ,.=::::!t=., ' -foregroundcolor "blue" -nonewline },
		{ Write-Host '` ' -foregroundcolor "red" -nonewline },
		{ Write-Host '@EEEEEEtttz33QF  ' -foregroundcolor "green" -nonewline } ),
	@(	{ Write-Host '   ;::::::::zt33)   ' -foregroundcolor "blue" -nonewline },
		{ Write-Host '"4EEEtttji3P*   ' -foregroundcolor "green" -nonewline } ),
	@(	{ Write-Host '  :t::::::::tt33.' -foregroundcolor "blue" -nonewline },
		{ Write-Host ' :Z3z.. `` ,..g.   ' -foregroundcolor "yellow" -nonewline } ),
	@(	{ Write-Host '  i::::::::zt33F ' -foregroundcolor "blue" -nonewline },
		{ Write-Host 'AEEEtttt::::ztF    ' -foregroundcolor "yellow" -nonewline } ),
	@( 	{ Write-Host ' ;:::::::::t33V ' -foregroundcolor "blue" -nonewline },
		{ Write-Host ';EEEttttt::::t3     ' -foregroundcolor "yellow" -nonewline } ),
	@(	{ Write-Host ' E::::::::zt33L ' -foregroundcolor "blue" -nonewline }, 
		{ Write-Host '@EEEtttt::::z3F     ' -foregroundcolor "yellow" -nonewline } ),
	@(	{ Write-Host '{3=*^```"*4E3) ' -foregroundcolor "blue" -nonewline },
		{ Write-Host ';EEEtttt:::::tZ`     ' -foregroundcolor "yellow" -nonewline } ),
	@(	{ Write-Host '             ` ' -foregroundcolor "blue" -nonewline },
		{ Write-Host ':EEEEtttt::::z7      ' -foregroundcolor "yellow" -nonewline } ),
	@(	{ Write-Host '                 ' -foregroundcolor "blue" -nonewline }, 
		{ Write-Host '"VEzjt:;;z>*`      ' -foregroundcolor "yellow" -nonewline } ),
	@(	{ Write-Host "`n" } )
)

# Returns an array of scriptblocks, containing the commands necessary to write one line of system information
Function Get-LineScriptBlock($Label, $Value, $LabelSize=11, $PadLeft = 4 ) {
	# Using [ScriptBlock]::Create rather than literal notation to force PowerShell to 
	# store value of variables in scriptblock, rather than the variables themselves.
	@( [ScriptBlock]::Create("Write-Host `"$(' ' * $PadLeft)$($Label.PadLeft($LabelSize)) `" -foregroundcolor Red -nonewline"),
    [ScriptBlock]::Create("Write-Host `"$Value`" -foregroundcolor White") )
}

# Array of arrays of script blocks, containing commands to write out system information
# Each sub-array should correspond to 1 line of information
$AllInfo = @(
	@(	{ Write-Host } ),
	@(	{ Write-Host } ),
	@(	{ Write-Host "    $USERNAME" -foregroundcolor "red" -nonewline; },
		{ Write-Host "@" -foregroundcolor "white" -nonewline; },
		{ Write-Host "$WORKSTATION" -foregroundcolor "yellow" } ),
	@(	{ Write-Host } ),
	$(Get-LineScriptBlock -Label "OS:" -Value "$OS $ARCH"),
	$(Get-LineScriptBlock -Label "CPU:" -Value "$CPU% utilization"),
	$(Get-LineScriptBlock -Label "Memory:" -Value $MEM),
	$(Get-LineScriptBlock -Label "Uptime:" -Value $UPTIME),
	$(Get-LineScriptBlock -Label "Resolution:" -Value $RESOLUTION),
	@(	{ Write-Host } ),
	$(Get-LineScriptBlock -Label "HDD:" -Value "$($driveSpecs[0].DriveLetter)`:`\ has $($driveSpecs[0].DriveFreeSpace) GB Free Space" )
)

# Add any drives besides the first
if ($driveSpecs.Count -gt 1) {
	$driveSpecs | Select-Object -Skip 1 | % {
		$AllInfo += ,$(Get-LineScriptBlock -Label "" -Value "$($_.DriveLetter)`:`\ has $($_.DriveFreeSpace) GB Free Space" )
	}
}

# Add enough blank lines so that $Logo and $AllInfo are the same size
while ($Logo.Count -gt $AllInfo.Count) {
	$AllInfo += @(	{ Write-Host } )
}

# Add enough blank lines so that $Logo and $AllInfo are the same size
while ($AllInfo.Count -gt $Logo.Count) {
	$Logo += @(	{ Write-Host } )
}

# Loop through both arrays and execute the script blocks
for ($i = 0; $i -lt $Logo.Count; $i++) {
	$Logo[$i] | % { & $_ }
	$AllInfo[$i] | % { & $_ }
}

# Take Screenshot if the Parameters are assigned...
if ( $Path ) {
    Take-Screenshot -Width $ScreenWidth -Height $ScreenHeight -TarPath $Path
}

