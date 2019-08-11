param(
    [string]$AccountName,
    [string]$AccountPassword,
    [string]$ResourceGroupName,

    [string]$ChefServerUrl,
    [string]$ChefValidationClientName,
    [string]$ChefValidationKey
)

#Preferencialmente utilizar um Service Principal, entretanto devido a impossibilidade de se realizar alteracoes no AzureAD, estou utilizando minha propria conta
$password = ConvertTo-SecureString "$($AccountPassword)" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($AccountName, $password)

$overrideParameters = @{}
$overrideParameters.Add("chefServerUrl",$ChefServerUrl)
$overrideParameters.Add("chefValidationClientName",$ChefValidationClientName)
$overrideParameters.Add("chefValidationKey",$ChefValidationKey)

Login-AzureRmAccount -Credential $credential

New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile .\azuredeploy.json `
    -TemplateParameterFile .\azuredeploy.parameters.json `
    -TemplateParameterObject $overrideParameters