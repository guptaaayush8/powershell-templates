$jsonFiles = Get-ChildItem -Path (Get-Location).Path -Filter "*.json" -Recurse

$InvalidTemplate = @()

foreach($jsonFile in $jsonFiles){
    try{
        $null = Get-Content -Path $jsonFile.FullName | Convertfrom-Json
    }
    catch{
        $InvalidTemplate += " $($JsonFile.Name) `n $($_.Exception)" 
    }
}

if($InvalidTemplate.Count -ne 0){
    
    throw "$InvalidTemplate"
    
}

else {
    "All JSONs are valid"

}

