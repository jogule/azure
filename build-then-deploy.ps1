$UTCNow = (Get-Date).ToUniversalTime()
$UTCTimeTick = $UTCNow.Ticks.tostring()
$Sufix = $UTCTimeTick.Substring(15,3)
$rgName = "myrg$Sufix"
$rgName

git commit -am "$rgName test"
git push

New-AzResourceGroup -Name $rgName -Location 'East US 2'

New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile .\CloudShopFromWebServerImage.json -uniqueSeedString $UTCTimeTick -asjob

#Remove-AzResourceGroup $rgName -Force -Asjob