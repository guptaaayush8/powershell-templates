param(
    $ResourceGroupName,
    $Location = "East US",
    $Role=@('Contributor'),
    $GroupID = @('25c3d51c-622d-43c6-9fde-b437dd1e2222')
)

$ResourceExist = Get-AzResourceGroup -Name $ResourceGroupName  -ErrorAction SilentlyContinue

if(-not $ResourceExist){
    Write-Host "resource group '$ResourceGroupName' does not exist, Creating it"
    try{
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location
        Write-Host "resource group created"
    }
    catch{
       throw $_.exception 
    }

}else{
    write-host "Resource Group Already Exist"
}

try{
    Write-Host "Attempting to give role - '$Role' to group id - '$GroupID'"
    New-AzRoleAssignment -ObjectId $GroupID -RoleDefinitionName $Role -ResourceGroupName $ResourceGroupName
}
catch{
    $_
    Write-Host "Role already exist"   
}

