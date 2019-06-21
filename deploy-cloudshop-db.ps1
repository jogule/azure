param($user, $password, $dbsource, $sqlConfigUrl, $correlationID, $rg)

$id=$correlationID
$rgname=$rg
$script="deploy-cloudshop.ps1"

$comment="starting script..."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA==&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing


$logs    = "C:\Logs"
$data    = "C:\Data"
$backups = "C:\Backup" 
$script  = "C:\Script" 

[system.io.directory]::CreateDirectory($logs)
[system.io.directory]::CreateDirectory($data)
[system.io.directory]::CreateDirectory($backups)
[system.io.directory]::CreateDirectory($script)
[system.io.directory]::CreateDirectory("C:\SQLDATA")

$comment="all dirs created..."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA==&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing

$splitpath = $sqlConfigUrl.Split("/")
$fileName = $splitpath[$splitpath.Length-1]
$destinationPath = "$script\configure-sql.ps1"
# Download config script
(New-Object Net.WebClient).DownloadFile($sqlConfigUrl,$destinationPath);

$comment="script downloaded..."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA==&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing

# Get the Adventure works database backup 
$dbdestination = "C:\SQLDATA\AdventureWorks2012.bak"
Invoke-WebRequest $dbsource -OutFile $dbdestination

$comment="database downloaded..."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA==&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing

$password =  ConvertTo-SecureString "$password" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("$env:COMPUTERNAME\$user", $password)

Enable-PSRemoting -force
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any
Invoke-Command -FilePath $destinationPath -Credential $credential -ComputerName $env:COMPUTERNAME -ArgumentList "Password", $password
Disable-PSRemoting -Force

$comment="script executed..."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA==&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing

New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action allow 

$comment="fw rule created..."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA==&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing

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

$comment="IE ESC disabled..."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA==&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing

$comment="script finished..."
$log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA==&id=$id&rgname=$rgname&script=$script&comment=$comment"
Invoke-WebRequest $log -UseBasicParsing

