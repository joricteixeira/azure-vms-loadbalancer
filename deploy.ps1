params(
    [string]$AccountName,
    [string]$AccountPassword,
    [string]$ResourceGroupName
)

#Preferencialmente utilizar um Service Principal, entretanto devido à impossibilidade de se realizar alteracoes no AzureAD, estou utilizando minha própria conta
$password = ConvertTo-SecureString "$($AccountPassword)" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($AccountName, $password)

Login-AzAccount -Credential $credential

New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile .\azuredeploy.json -TemplateParameterFile .\azuredeploy.parameters.json