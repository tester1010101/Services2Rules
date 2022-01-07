##################################################
#            ~ Services_to_Rules v1.2 ~          #
# ._.        ~ Made by: tester1010101 ~      ._. #
# Converts all currently installed services to   #
# Firewall Rules with their matching short name, #
#       & the corresponding fullname. ~.~        #
#            github.com/tester1010101/           #
##################################################
$ASCIIDate = Get-Date -Format MM_dd_yyyy-HH_mm_ss
mkdir $ENV:USERPROFILE\0xFF\Services2Rules\ -ErrorAction SilentlyContinue 
Get-Service | Select Name | Export-Csv $ENV:USERPROFILE\0xFF\Services2Rules\short-$ASCIIDate.csv
Move-Item $ENV:USERPROFILE\0xFF\Services2Rules\short-$ASCIIDate.csv $ENV:USERPROFILE\0xFF\Services2Rules\short-$ASCIIDate.txt
Get-Service | Select DisplayName | Export-Csv $ENV:USERPROFILE\0xFF\Services2Rules\long-$ASCIIDate.csv
Move-Item $ENV:USERPROFILE\0xFF\Services2Rules\long-$ASCIIDate.csv $ENV:USERPROFILE\0xFF\Services2Rules\long-$ASCIIDate.txt
$Shorts = (Get-Content $ENV:USERPROFILE\0xFF\Services2Rules\short-$ASCIIDate.txt).TrimStart("`"").TrimEnd("`"")
$Longs = (Get-Content $ENV:USERPROFILE\0xFF\Services2Rules\long-$ASCIIDate.txt).TrimStart("`"").TrimEnd("`"")

[int]$Count1 = ($Shorts.Length)
[int]$Count2 = ($Longs.Length)
if ($Count1 -eq $Count2)
{
    Write-Host "Ok. Continue? [Y/N]" -ForegroundColor Green
    $Answer = Read-Host
    if ($Answer -match "N")
    {
        Exit
    }
}

Write-Host "Working, please wait." -ForegroundColor Yellow

for ($i = 0; $i -lt $Count1; $i++)
{ 
    $ShortSer = $Shorts[$i]
    $LongName = $Longs[$i]
    $Cmd = "netsh advfirewall firewall add rule name='$LongName' enable=No dir=Out profile=Domain,Private,Public localip='Any' remoteip='Any' protocol='Any' edge='No' program='$env:SystemRoot\system32\svchost.exe' service='$ShortSer' interface='Any' security='NotRequired' action='Allow'"
    $Cmds += ($Cmd + "`n")
}

$Cmds | Out-File $env:USERPROFILE\0xFF\Services2Rules\Services_Commands-$ASCIIDate.txt

Write-Host "Completed successfully. Exported at: $env:USERPROFILE\0xFF\Services2Rules\Services_Commands-$ASCIIDate.txt" -ForegroundColor Cyan
Write-Host "Open file? [Y/N]" -ForegroundColor Yellow
$Answer = Read-Host
if ($Answer -match "Y")
{
    explorer $env:USERPROFILE\0xFF\Services2Rules\
    explorer $env:USERPROFILE\0xFF\Services2Rules\Services_Commands-$ASCIIDate.txt
}

$Answer = $null
pause