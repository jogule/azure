param($user, $password, $dbsource, $sqlConfigUrl, $correlationID, $rg, $environment)

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
    $code="tGODd2b9/1K5lvzEjOy5FjTOETPVN9/IP43oxn29BTOKooGDLOuW7Q=="
    $log = "https://test-myapp-jonguz.azurewebsites.net/api/TestSuccess?code=$code&id=$id&rgname=$rgname&script=$scriptname&comment=$comment"
    if($environment -eq "develop")
    {
        Invoke-WebRequest $log -UseBasicParsing -ErrorAction Continue
        Write-Host $log -ForegroundColor Green
    }    
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$scriptname="deploy-cloudshop-db.ps1"
WebLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "starting script..." -environment $environment

$logs    = "C:\Logs"
$data    = "C:\Data"
$backups = "C:\Backup" 
$script  = "C:\Script"
[system.io.directory]::CreateDirectory($logs)
[system.io.directory]::CreateDirectory($data)
[system.io.directory]::CreateDirectory($backups)
[system.io.directory]::CreateDirectory($script)
[system.io.directory]::CreateDirectory("C:\SQLDATA")
WebLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "all data folders created..." -environment $environment

#$splitpath = $sqlConfigUrl.Split("/")
#$fileName = $splitpath[$splitpath.Length-1]
$destinationPath = "$script\configure-sql.ps1"
# Download config script
(New-Object Net.WebClient).DownloadFile($sqlConfigUrl,$destinationPath);
WebLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "script downloaded..." -environment $environment

# Get the Adventure works database backup 
$dbdestination = "C:\SQLDATA\AdventureWorks2012.bak"
Invoke-WebRequest $dbsource -OutFile $dbdestination
WebLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "database downloaded..." -environment $environment

$password =  ConvertTo-SecureString "$password" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("$env:COMPUTERNAME\$user", $password)

Enable-PSRemoting -force
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any
Invoke-Command -FilePath $destinationPath -Credential $credential -ComputerName $env:COMPUTERNAME -ArgumentList $password
Disable-PSRemoting -Force
WebLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "script executed..." -environment $environment

New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action allow 
WebLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "fw rule created..." -environment $environment

WebLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "script finished..." -environment $environment

#Start-Sleep 10
#TestLog -id $correlationID -rgname $rg -scriptname $scriptname -comment "test performed..." -environment $environment

