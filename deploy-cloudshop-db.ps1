param($user, $password, $dbsource, $sqlConfigUrl, $correlationID, $rg)

function WebLog {
    param (
        $code,
        $id,
        $rgname,
        $scriptname,
        $comment
    )
    $log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=$code&id=$id&rgname=$rgname&script=$scriptname&comment=$comment"
    Invoke-WebRequest $log -UseBasicParsing -ErrorAction Continue
    Write-Host $log -ForegroundColor Green
}
function TestLog {
    param (
        $code,
        $id,
        $rgname,
        $scriptname,
        $comment
    )      
    $log = "https://test-myapp-jonguz.azurewebsites.net/api/TestSuccess?code=$code&id=$id&rgname=$rgname&script=$scriptname&comment=$comment"
    Invoke-WebRequest $log -UseBasicParsing -ErrorAction Continue
    Write-Host $log -ForegroundColor Green
}

function Disable-IEESC {
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
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$scriptname="deploy-cloudshop-db.ps1"
$code="rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA=="
$codeTest = "tGODd2b9/1K5lvzEjOy5FjTOETPVN9/IP43oxn29BTOKooGDLOuW7Q=="
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "starting script..."

$logs    = "C:\Logs"
$data    = "C:\Data"
$backups = "C:\Backup" 
$script  = "C:\Script"
[system.io.directory]::CreateDirectory($logs)
[system.io.directory]::CreateDirectory($data)
[system.io.directory]::CreateDirectory($backups)
[system.io.directory]::CreateDirectory($script)
[system.io.directory]::CreateDirectory("C:\SQLDATA")
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "all data folders created..."

$splitpath = $sqlConfigUrl.Split("/")
$fileName = $splitpath[$splitpath.Length-1]
$destinationPath = "$script\configure-sql.ps1"
# Download config script
(New-Object Net.WebClient).DownloadFile($sqlConfigUrl,$destinationPath);
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "script downloaded..."

$dbPath = "C:\SQLDATA\AdventureWorks2012.zip"
$destinationFolder = "C:\SQLDATA"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($dbsource,$dbPath)
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "db downloaded...."

(new-object -com shell.application).namespace($destinationFolder).CopyHere((new-object -com shell.application).namespace($destinationPath).Items(),16)
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "db unzipped...."

$password =  ConvertTo-SecureString "$password" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("$env:COMPUTERNAME\$user", $password)

Enable-PSRemoting -force
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any
Invoke-Command -FilePath $destinationPath -Credential $credential -ComputerName $env:COMPUTERNAME -ArgumentList $password
Disable-PSRemoting -Force
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "script executed..."

New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action allow 
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "fw rule created..."

Disable-IEESC
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "IE ESC disabled..."

WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "script finished..."

Start-Sleep 30

TestLog -code $codeTest -id $correlationID -rgname $rg -scriptname $scriptname -comment "test performed..."

