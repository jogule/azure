param($cloudShopUrl, $correlationID, $rg)

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
$scriptname="deploy-cloudshop.ps1"
$code="rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA=="
$codeTest = "tGODd2b9/1K5lvzEjOy5FjTOETPVN9/IP43oxn29BTOKooGDLOuW7Q=="
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "starting script..."

add-WindowsFeature -Name "Web-Server" -IncludeAllSubFeature
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "Web server enabled...."

$splitpath = $cloudShopUrl.Split("/")
$fileName = $splitpath[$splitpath.Length-1]
$destinationPath = "C:\Inetpub\wwwroot\CloudShop.zip"
$destinationFolder = "C:\Inetpub\wwwroot"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($cloudShopUrl,$destinationPath)
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "app downloaded...."

(new-object -com shell.application).namespace($destinationFolder).CopyHere((new-object -com shell.application).namespace($destinationPath).Items(),16)
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "app unzipped...."


Disable-IEESC
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "IE ESC disabled..."

WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "script finished..."

Start-Sleep 60

TestLog -code $codeTest -id $correlationID -rgname $rg -scriptname $scriptname -comment "test performed..."

