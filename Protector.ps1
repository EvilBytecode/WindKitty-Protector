class AntiLogging {
    [string]$basicstartup
    [string[]]$badextenstion
    [string]$uacstartup

    AntiLogging() {
        $this.basicstartup = Join-Path $env:USERPROFILE 'AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'
        $this.uacstartup = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup'
        $this.badextenstion = @(".src", ".scr", ".js", ".cpp", ".cs", ".exe", ".bat", ".ps1")
    }

    [void]del() {
        $this.del($this.basicstartup)
        $this.del($this.uacstartup)
        $this.killinjection()
        $this.NMR()
        Read-Host "Press any key to exit..."
    }

    [void]del($dir) {
        if (Test-Path $dir) {
            $KFC = Get-ChildItem -Path $dir -File

            if ($KFC.Count -eq 0) {
                Write-Host "[+] No Malicious Files Have been found in startups." -ForegroundColor Green
            }

            foreach ($nagas in $KFC) {
                if ($this.badextenstion -contains $nagas.Extension) {
                    $res = $this.delfile($nagas.FullName)
                    if ($res -eq 'y') {
                        Remove-Item $nagas.FullName -Force
                        Write-Host "[+] File '$($nagas.Name)' removed." -ForegroundColor Green
                    }
                    else {
                        Write-Host "[-} File '$($nagas.Name)' not removed." -ForegroundColor Red
                    }
                }
            }
        }
        else {
            Write-Host "[=] Directory '$dir' not found." -ForegroundColor Yellow
        }
    }

    [string]delfile($pth) {
        $resp = Read-Host "Do you want to remove the file '$pth'? (y/n)"  -ForegroundColor Yellow
        return $resp.ToLower()
    }

    [void]killinjection() {
        $discPathUwu = Join-Path $env:LOCALAPPDATA 'Discord'
        $kfc = Get-ChildItem $discPathUwu | Where-Object { $_.Name -like 'app-*' }

        $infected = $false

        foreach ($mafaka in $kfc) {
            $david = Join-Path $mafaka.FullName 'modules\discord_desktop_core-1\discord_desktop_core\index.js'
            $size1kb = (Get-Item $david).Length / 1KB
            $balls = Get-Content $david -Raw

            if ($size1kb -gt 1 -and $balls -ne "module.exports = require('./core.asar');") {
                Set-Content -Path $david -Value "module.exports = require('./core.asar');"
                $infected = $true
                Write-Host "[-] Discord was infected." -ForegroundColor Red
            }
        }

        if ($infected -eq $false) {
            Write-Host "[+] Discord wasn't infected." -ForegroundColor Green
        }
    }

    [void]NMR() {
        $NMR = "https://github.com/AdvDebug/NoMoreCookies/releases/download/NoMoreCookies_2.3/NoMoreCookies-2.3.zip"
    
        $NMRD = $null
        Write-Host "`n"
        Write-Host "[NOMORECOOKIES] This Protects you from Rats And Grabbers.." -ForegroundColor Red
        Write-Host "[+] Protects from Known Rats Like: AsyncRAT, Quasar RAT, Venom Rat, XWorm RAT, DC Rat etc.." -ForegroundColor Red
        Write-Host "[+] And also from known grabbers such as: Redline Stealer, Blank Stealer, Umbral Stealer etc.." -ForegroundColor Red
        Write-Host "`n"
        $inp = Read-Host "Do you want to install NoMoreCookies? $NMR ? (y/n)" 
        if ($inp.ToLower() -eq 'y') {
            $NMRD = $true
        }

        if ($NMRD) {
            $exten = [System.IO.Path]::GetExtension($NMR)
            $des = Join-Path $env:USERPROFILE "Downloads\NoMoreCookies$exten"
            
            Invoke-WebRequest -Uri $NMR -OutFile $des -ErrorAction SilentlyContinue
            Write-Host "NMR Saved to: $des"
        
            $2xtract = Join-Path $env:USERPROFILE "Downloads\NoMoreCookiesExtracted"
            Expand-Archive -Path $des -DestinationPath $2xtract -Force
        
            $strtproc = Join-Path $2xtract "NoMoreCookiesInstaller.exe"
            Start-Process -FilePath $strtproc -Wait
            Write-Host "NoMoreCookiesInstaller.exe executed successfully."
        }
    }
}

##############################################################################################
## forgot to add this mb gng that its not in class lol but i seen some sh

function Cleanup {
    Unregister-ScheduledTask -TaskName "KDOT" -Confirm:$False
    Remove-Item -Path "$env:appdata\KDOT" -force -recurse
    Remove-MpPreference -ExclusionPath "$env:APPDATA\KDOT"
    Remove-MpPreference -ExclusionPath "$env:LOCALAPPDATA\Temp"
    Write-Host "[~] Successfully Uninstalled !" -ForegroundColor Green
}
Cleanup


$dirs = @(
    [System.IO.Path]::Combine($env:APPDATA, 'Microsoft\Windows\Start Menu\Programs\Startup'),
    'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup'
)

foreach ($pth in $dirs) {
    $hidshit = Get-ChildItem -Path $pth -Force | Where-Object { $_.Attributes -band ([System.IO.FileAttributes]::Hidden -bor [System.IO.FileAttributes]::System) }

    if ($hidshit) {
        Write-Host "[+] Found sum y should remove it if its executable:  $pth :" -ForegroundColor Yellow
        $hidshit | ForEach-Object {
            Write-Host $_.FullName
        }
    }
}
##############################################################################################


$ErrorActionPreference = 'SilentlyContinue' 
$ProgressPreference = 'SilentlyContinue' 

$uac = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $uac) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$antiLogging = [AntiLogging]::new()
$antiLogging.del()
