param($scenarioNumber = 3, $environment = "develop")

$templateURI = "https://raw.githubusercontent.com/jogule/azure/$environment/Scenario$scenarioNumber.json"
$templateURI
$UTCNow = (Get-Date).ToUniversalTime()
$UTCTimeTick = $UTCNow.Ticks.tostring()
$UTCTimeTick = "j" + $UTCTimeTick.Substring(0,17)
$Sufix = $UTCTimeTick.Substring(15,3)
$rgName = "myrg$Sufix"
$rgName

git commit -am "$rgName test"
git push origin $environment

New-AzResourceGroup -Name $rgName -Location 'East US 2'

New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateURI $templateURI -uniqueSeedString $UTCTimeTick -environment $environment

Start-Sleep 5*60

Remove-AzResourceGroup $rgName -Force -Asjob