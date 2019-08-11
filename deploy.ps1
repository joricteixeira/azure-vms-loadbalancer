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

Login-AzureRmAccount -Credential $credential

New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile .\azuredeploy.json `
    -TemplateParameterFile .\azuredeploy.parameters.json `
    -chefServerUrl $ChefServerUrl `
    -chefValidationClientName $ChefValidationClientName `
    -chefValidationKey $ChefValidationKey