#CredSetup
$Token = '3umjnantc74nqtzgl44726j7yccciuhoadffvpw6d564pjjxe4hq'
$Auth = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($Token)")) }


#fetchAllRepos

$projUrl = "https://dev.azure.com/LyondellBasell/Cloud Integration/_apis/git/repositories?includeLinks=True&includeAllUrls=True&includeHidden=True&api-version=5.0"
$Repo = Invoke-RestMethod -Method Get -Uri $projUrl -Headers $Auth

$Names = ($Repo.value.name|? {$_.startswith('rg')}) -replace 'rg-',$1

#Create Variable Groups
$CommonURI = "https://dev.azure.com/LyondellBasell/Cloud Integration/_apis/distributedtask/variablegroups?api-version=6.0-preview.2"

foreach($Name in $Names|sort){

$Var2 =  "{
    'name': 'Library',
    'type': 'Vsts',
    'variables': {
        'rg-dev': {
            'isSecret': false,
            'value': 'rg-$Name-dev'
        },
        'rg-nonprd': {
            'isSecret': false,
            'value': 'rg-$Name-nonprd'
        },
        'rg-nonprd2': {
            'isSecret': false,
            'value': 'rg-$Name-nonprd'
        },
        'rg-prd': {
            'isSecret': false,
            'value': 'rg-$Name-prd'
        }}, 
    'variableGroupProjectReferences': [{
        'name': 'var-lc-$Name',
        'projectReference': {
            'name': 'Cloud Integration'
        }
    }]
}"

 Invoke-RestMethod -Method Post -Uri $CommonURI -Headers $Auth -Body $var2 -ContentType 'application/json'

 }

#UpdateAll Variable Groups

 $CommonURI = "https://dev.azure.com/LyondellBasell/Cloud Integration/_apis/distributedtask/variablegroups/$GroupID?api-version=6.0-preview.2"

 foreach($Name in $Names|sort){

$Var2 =  "{
    'name': 'Library',
    'type': 'Vsts',
    'variables': {
        'rg-dev': {
            'isSecret': false,
            'value': 'rg-$Name-dev'
        },
        'rg-nonprd': {
            'isSecret': false,
            'value': 'rg-$Name-nonprd'
        },
        'rg-nonprd2': {
            'isSecret': false,
            'value': 'rg-$Name-nonprd'
        },
        'rg-prd': {
            'isSecret': false,
            'value': 'rg-$Name-prd'
        }}, 
    'variableGroupProjectReferences': [{
        'name': 'var-lc-$Name',
        'projectReference': {
            'name': 'Cloud Integration'
        }
    }]
}"

 Invoke-RestMethod -Method Put -Uri $CommonURI -Headers $Auth -Body $var2 -ContentType 'application/json'

 }