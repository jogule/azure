param($cloudShopUrl, $correlationID="id", $rg="default")

#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$id=$correlationID
$rgname=$rg
$script="deploy-cloudshop.ps1"
$code="rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA=="

$comment="starting script..."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=$code&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing
Write-Host $log

add-WindowsFeature -Name "Web-Server" -IncludeAllSubFeature

$comment="Web server enabled...."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=$code&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing
Write-Host $log

$splitpath = $cloudShopUrl.Split("/")
$fileName = $splitpath[$splitpath.Length-1]

$destinationPath = "C:\Inetpub\wwwroot\CloudShop.zip"
$destinationFolder = "C:\Inetpub\wwwroot"

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($cloudShopUrl,$destinationPath)

$comment="app downloaded...."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=$code&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing
Write-Host $log

(new-object -com shell.application).namespace($destinationFolder).CopyHere((new-object -com shell.application).namespace($destinationPath).Items(),16)

$comment="app copied...."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=$code&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing
Write-Host $log


# Disable IE Enhanced Security Configuration
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"

New-Item -Path $adminKey -Force
New-Item -Path $UserKey -Force
New-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
New-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0

$HKLM = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1"
$HKCU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1"
Set-ItemProperty -Path $HKLM -Name "1803" -Value 0
Set-ItemProperty -Path $HKCU -Name "1803" -Value 0
$HKLM = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2"
$HKCU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2"
Set-ItemProperty -Path $HKLM -Name "1803" -Value 0
Set-ItemProperty -Path $HKCU -Name "1803" -Value 0
$HKLM = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"
$HKCU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"
Set-ItemProperty -Path $HKLM -Name "1803" -Value 0
Set-ItemProperty -Path $HKCU -Name "1803" -Value 0
$HKLM = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4"
$HKCU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4"
Set-ItemProperty -Path $HKLM -Name "1803" -Value 0
Set-ItemProperty -Path $HKCU -Name "1803" -Value 0
$HKLM = "HKLM:\Software\Microsoft\Internet Explorer\Security"
New-ItemProperty -Path $HKLM -Name "DisableSecuritySettingsCheck" -Value 1 -PropertyType DWORD

Stop-Process -Name Explorer
Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green

$comment="IE ESC disabled...."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=$code&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing
Write-Host $log

$comment="script finished...."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=$code&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing
Write-Host $log