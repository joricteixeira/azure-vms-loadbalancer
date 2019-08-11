param(
    [string]$AccountName,
    [string]$AccountPassword,
    [string]$ResourceGroupName,

    [hashtable]$ExtraParameters
)

#Preferencialmente utilizar um Service Principal, entretanto devido a impossibilidade de se realizar alteracoes no AzureAD, estou utilizando minha propria conta
$password = ConvertTo-SecureString "$($AccountPassword)" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($AccountName, $password)

#Hack para unir parametros oriundos do template com parametros externos oriundos do buildserver ou etc
$params = Get-Content .\azuredeploy.parameters.json | ConvertFrom-Json
$templateParameter = @{}
foreach($p in $params.parameters.PSObject.Properties){
    if($p.Value.value -eq $null -or $p.Value.value -eq ""){
        Write-Host "Pulando parametro [$($p.Name)]"
    }else{
        Write-Host "Adicionando parametro [$($p.Name)]"
        $templateParameter.Add($p.Name,$p.Value.value)
    }
}
$templateParameter += $ExtraParameters

Login-AzureRmAccount -Credential $credential

New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile .\azuredeploy.json `
    -TemplateParameterObject $templateParameter