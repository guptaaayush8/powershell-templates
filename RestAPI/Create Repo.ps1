$LYBPAT = '3umjnantc74nqtzgl44726j7yccciuhoadffvpw6d564pjjxe4hq'

$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($LYBPAT)")) }

$projUrl = "https://dev.azure.com/LyondellBasell/Cloud Integration/_apis/git/repositories?api-version=5.0"

$repoBody = @{
    name = "TestRepo"
} | ConvertTo-Json

Invoke-WebRequest -method Post -Headers $AzureDevOpsAuthenicationHeader -body $repoBody -Uri $projUrl -ContentType "application/json" -UseBasicParsing


#$projUrl = "https://dev.azure.com/LyondellBasell/Cloud Integration/_apis/git/repositories?includeLinks=True&includeAllUrls=True&includeHidden=True&api-version=5.0"