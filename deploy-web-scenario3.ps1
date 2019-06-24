param($cloudShopUrl, $correlationID, $rg, $environment)

function WebLog {
    param (
        $id,
        $rgname,
        $scriptname,
        $comment,
        $environment
    )
    $code="rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA=="
    $log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=$code&id=$id&rgname=$rgname&script=$scriptname&comment=$comment"
    if($environment -eq "develop")
    {
        Invoke-WebRequest $log -UseBasicParsing -ErrorAction Continue
        Write-Host $log -ForegroundColor Green
    }    
}
function TestLog {
    param (
        $id,
        $rgname,
        $scriptname,
        $comment,
        $environment
    )
    $code = "tGODd2b9/1K5lvzEjOy5FjTOETPVN9/IP43oxn29BTOKooGDLOuW7Q=="
    $log = "https://test-myapp-jonguz.azurewebsites.net/api/TestSuccess?code=$code&id=$id&rgname=$rgname&script=$scriptname&comment=$comment"
    if($environment -eq "develop")
    {
        Invoke-WebRequest $log -UseBasicParsing -ErrorAction Continue
        Write-Host $log -ForegroundColor Green
    }
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$scriptname="deploy-cloudshop.ps1"
WebLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "starting script..." -environment $environment

#add-WindowsFeature -Name "Web-Server" -IncludeAllSubFeature
#WebLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "Web server enabled...." -environment $environment

#$splitpath = $cloudShopUrl.Split("/")
#$fileName = $splitpath[$splitpath.Length-1]
$destinationPath = "C:\Inetpub\wwwroot\CloudShop.zip"
$destinationFolder = "C:\Inetpub\wwwroot"
(New-Object Net.WebClient).DownloadFile($cloudShopUrl,$destinationPath)
WebLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "app downloaded...." -environment $environment

(new-object -com shell.application).namespace($destinationFolder).CopyHere((new-object -com shell.application).namespace($destinationPath).Items(),16)
WebLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "app unzipped...." -environment $environment

WebLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "script finished..." -environment $environment

#Start-Sleep 30
#TestLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "test performed..." -environment $environment

