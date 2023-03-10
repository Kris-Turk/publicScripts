# Setup ICMPv4 Access
if(!(Get-NetFirewallRule -Name AllowICMPv4 -ErrorAction SilentlyContinue)){
    New-NetFirewallRule -Name 'AllowICMPv4' -DisplayName 'AllowICMPv4' -Profile 'Any' -Direction 'Inbound' -Action 'Allow' -Protocol 'ICMPv4' -Program 'Any' -LocalAddress 'Any' -RemoteAddress 'Any'
    }
else {
    Write-Host 'Firewall rule "AllowICMPv4" already exists'
}


if(!(get-item 'C:\Program Files (x86)\Freshdesk\Freshservice Discovery Agent\')){
    # Install the Freshservice Agent for Reboot
    $drive = 'C:\Packages'
    $appName = 'fs-windows-agent-2.9.0'
    New-Item -Path $drive -Name $appName -ItemType Directory -ErrorAction SilentlyContinue
    $LocalPath = $drive + '\' + $appName
    Set-Location -Path $LocalPath
    $URL = 'https://raw.githubusercontent.com/CIPDRepo/VLZ/main/fs-windows-agent-2.9.0.msi'
    $msi = 'fs-windows-agent-2.9.0.msi'
    $outputPath = $LocalPath + '\' + $msi
    Invoke-WebRequest -Uri $URL -OutFile $outputPath
    write-host 'Starting the install of fs-windows-agent-2.9.0'
    Start-Process -FilePath msiexec.exe -Args "/package $outputPath /quiet" -Wait
    write-host 'Finished the install of fs-windows-agent-2.9.0'
    }
else {
    write-host "Fresh service agent already installed"
}

# Install the Datto Agent for Servium
if(!(get-item 'C:\Program Files (x86)\CentraStage\cagService.exe')){
    $drive = 'C:\Packages'
    $appName = 'Datto'
    New-Item -Path $drive -Name $appName  -ItemType Directory -ErrorAction SilentlyContinue
    $LocalPath = $drive + '\' + $appName 
    set-Location $LocalPath
    $URL = 'https://raw.githubusercontent.com/CIPDRepo/VLZ/main/DattoAgent.exe'
    $URLexe = 'DattoAgent.exe'
    $outputPath = $LocalPath + '\' + $URLexe
    Invoke-WebRequest -Uri $URL -OutFile $outputPath
    write-host 'Starting the install of Datto Agent'
    Start-Process -FilePath $outputPath -Args "/install /VERYSILENT"
    write-host 'Finished the install of Datto Agent'
    }
    else {
        write-host "Datto Agent already installed"
    }

# Turn off IE Enhanced Security Configuration for Administrators
function Disable-InternetExplorerESC {
    Write-Host "Disabling IE Enhanced Security Configuration (ESC)..."
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 1
    Stop-Process -Name Explorer -Force
}
# Disable ESC
Disable-InternetExplorerESC

# Set GMT as the Timezone
Set-TimeZone -Id "GMT Standard Time"
