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

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$scriptname="deploy-cloudshop.ps1"
$code="rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA=="
$codeTest = "tGODd2b9/1K5lvzEjOy5FjTOETPVN9/IP43oxn29BTOKooGDLOuW7Q=="
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "starting script..."

#add-WindowsFeature -Name "Web-Server" -IncludeAllSubFeature
#WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "Web server enabled...."

#$splitpath = $cloudShopUrl.Split("/")
#$fileName = $splitpath[$splitpath.Length-1]
$destinationPath = "C:\Inetpub\wwwroot\CloudShop.zip"
$destinationFolder = "C:\Inetpub\wwwroot"
(New-Object Net.WebClient).DownloadFile($cloudShopUrl,$destinationPath)
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "app downloaded...."

(new-object -com shell.application).namespace($destinationFolder).CopyHere((new-object -com shell.application).namespace($destinationPath).Items(),16)
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "app unzipped...."

WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "script finished..."

#Start-Sleep 30
#TestLog -code $codeTest -id $correlationID -rgname $rg -scriptname $scriptname -comment "test performed..."

