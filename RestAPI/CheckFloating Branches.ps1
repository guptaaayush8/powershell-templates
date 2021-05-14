$LYBPAT = '3umjnantc74nqtzgl44726j7yccciuhoadffvpw6d564pjjxe4hq'

$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($LYBPAT)")) }

$projUrl = "https://dev.azure.com/LyondellBasell/Cloud Integration/_apis/git/repositories/?includeLinks=True&includeAllUrls=True&includeHidden=True&api-version=5.0"

$repoBody = @{
    name = "TestRepo"
} | ConvertTo-Json

#$Repo = Invoke-RestMethod -method Post -Headers $AzureDevOpsAuthenicationHeader -body $repoBody -Uri $projUrl -ContentType "application/json" -UseBasicParsing
$Repo = Invoke-RestMethod -Headers $AzureDevOpsAuthenicationHeader -Uri $projUrl
$Branches = @()
foreach($r in $repo.value){
    $uri = "https://dev.azure.com/LyondellBasell/Cloud Integration/_apis/git/repositories/$($r.id)/refs?api-version=6.0"
    $p = Invoke-RestMethod -Headers $AzureDevOpsAuthenicationHeader -Uri $uri
    
    foreach($i in $p.value){
        
        
        $Branches += [pscustomobject]@{Repo = $R.name; Branch = $i.name; Creator = $i.creator.displayName}
    }
}
$Branches|sort -Property repo

$projUrl = "https://dev.azure.com/LyondellBasell/_apis/distributedtask/yamlschema?api-version=5.1"
