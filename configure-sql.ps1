param($password, $correlationID, $rg)
function WebLog {
    param (
        $code,
        $id,
        $rgname,
        $scriptname,
        $comment
    )
    $log = "https://test-myapp-jonguz.azurewebsites.net/api/LogSuccess?code=$code&id=$id&rgname=$rgname&script=$scriptname&comment=$comment"
    Invoke-WebRequest $log -UseBasicParsing
    Write-Host $log -ForegroundColor Green
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$scriptname="configure-sql.ps1"
$code="rF7HuLnP2apBtEXym3fkj6/5bX0ToahjzaDxE2BStsRYO6aURKZgFA=="

WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "starting script..."

$dbdestination = "C:\SQLDATA\AdventureWorks2012.bak"
# Setup the data, backup and log directories as well as mixed mode authentication
Import-Module "sqlps" -DisableNameChecking
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
$sqlesq = new-object ('Microsoft.SqlServer.Management.Smo.Server') Localhost
$sqlesq.Settings.LoginMode = [Microsoft.SqlServer.Management.Smo.ServerLoginMode]::Mixed
$sqlesq.Settings.DefaultFile = $data
$sqlesq.Settings.DefaultLog = $logs
$sqlesq.Settings.BackupDirectory = $backups
$sqlesq.Alter() 

WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "directories setup data=$data logs=$logs backups=$backups..."

# Restart the SQL Server service
Restart-Service -Name "MSSQLSERVER" -Force


WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "sql restarted..."

# Re-enable the sa account and set a new password to enable login
Invoke-Sqlcmd -ServerInstance Localhost -Database "master" -Query "ALTER LOGIN sa ENABLE" 
Invoke-Sqlcmd -ServerInstance Localhost -Database "master" -Query "ALTER LOGIN sa WITH PASSWORD = 'demo@pass123'"


WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "sa enabled..."

$mdf = New-Object 'Microsoft.SqlServer.Management.Smo.RelocateFile, Microsoft.SqlServer.SmoExtended, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91' -ArgumentList "AdventureWorks2012_Data", "C:\Data\AdventureWorks2012.mdf"
$ldf = New-Object 'Microsoft.SqlServer.Management.Smo.RelocateFile, Microsoft.SqlServer.SmoExtended, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91' -ArgumentList "AdventureWorks2012_Log", "C:\Logs\AdventureWorks2012.ldf"



# Restore the database from the backup
Restore-SqlDatabase -ServerInstance Localhost -Database AdventureWorks `
			-BackupFile $dbdestination -RelocateFile @($mdf,$ldf)  

		
WebLog -code $code -id $correlationID -rgname $rg -scriptname $scriptname -comment "data files restored mdf=$mdf ldf=$ldf..."

