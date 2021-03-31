param(
    $ResourceGroupName,
    $Role=@('Contributor'),
    $GroupID = @('25c3d51c-622d-43c6-9fde-b437dd1e2222')
)


if(-not $ResourceExist){
    New-AzResourceGroup -Name $ResourceGroupName -Location "East US"
}else{
    write-host "Resource Already Exist"
}

try{
    New-AzRoleAssignment -ObjectId $GroupID -RoleDefinitionName "Contributor" -ResourceGroupName $ResourceGroupName
}
catch{
    $_   
}

