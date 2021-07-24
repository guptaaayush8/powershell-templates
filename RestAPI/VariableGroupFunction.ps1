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
        'rg-systemapp-dev': {
            'isSecret': false,
            'value': 'rg-integration-systemapp-dev'
        },
        'rg-systemapp-nonprd': {
            'isSecret': false,
            'value': 'rg-integration-systemapp-nonprd'
        },
        'rg-systemapp-prd': {
            'isSecret': false,
            'value': 'rg-integration-systemapp-prd'
        },
        'funapp-dev': {
            'isSecret': false,
            'value': 'azfun-$Name-dev'
        },
        'funapp-nonprd': {
            'isSecret': false,
            'value': 'azfun-$Name-nonprd'
        },
        'funapp-prd': {
            'isSecret': false,
            'value': 'azfun-$name-prd'
        },
        'rg-prd': {
            'isSecret': false,
            'value': 'rg-$Name-prd'
        },
        'rg-apim-dev': {
            'isSecret': false,
            'value': 'rg-apiplatform-nonprd'
        },
        'rg-apim-nonprd': {
            'isSecret': false,
            'value': 'rg-apiplatform-nonprd'
        },
        'rg-apim-prd': {
            'isSecret': false,
            'value': 'rg-apiplatform-prd'
        }}, 
    'variableGroupProjectReferences': [{
        'name': 'var-lc-$Name',
        'projectReference': {
            'name': 'Cloud Integration'
        }
    }]
}"

 try{Invoke-RestMethod -Method Post -Uri $CommonURI -Headers $Auth -Body $var2 -ContentType 'application/json'}catch{}
 $uri="https://dev.azure.com/lyondellbasell/cloud integration/_apis/distributedtask/environments?api-version=6.0-preview.1"
$aurl = "https://dev.azure.com/LyondellBasell/c6855c89-1670-45cc-81de-81f5db52ce94/_apis/pipelines/checks/configurations?api-version=6.0-preview.1"

$devenvbody = "{
    'name':'rg-$Name-dev',
    'description':'Environment for rg-$Name-dev'
}"
$nonprdenvbody = "{
    'name':'rg-$Name-nonprd',
    'description':'Environment for rg-$Name-nonprd'
}"
$prdenvbody = "{
    'name':'rg-$Name-prd',
    'description':'Environment for rg-$Name-prd'
}"
try{
    $devENVOUT = Invoke-RestMethod -Method Post -Uri $uri -Headers $Auth -Body $devenvbody -ContentType 'application/json'
}catch{}
try{
    $nonprdENVOUT = Invoke-RestMethod -Method Post -Uri $uri -Headers $Auth -Body $nonprdenvbody -ContentType 'application/json'
    $devjson = "{
  'type': {
    'id': '8C6F20A7-A545-4486-9777-F762FAFE0D4D',
    'name': 'Approval'
  },
  'settings': {
    'approvers': [
      {
        'displayName': '[Cloud Integration]\\Dev Testers',
        'id': '902f9bae-0c71-43c4-a555-c1f6985e9907',
        'descriptor': 'vssgp.Uy0xLTktMTU1MTM3NDI0NS00MDMwMDI5MDM2LTQxMzAwMDUyNi0yMTc2NDI1Njc3LTE2MzE3Mzc3MTgtMS0xNzgxNjIzNDAwLTEwNzAxOTM0ODItMjk1MDA4NTkxMi00NDYyNTU0Mzk',
        'imageUrl': '/LyondellBasell/_apis/GraphProfile/MemberAvatars/vssgp.Uy0xLTktMTU1MTM3NDI0NS00MDMwMDI5MDM2LTQxMzAwMDUyNi0yMTc2NDI1Njc3LTE2MzE3Mzc3MTgtMS0xNzgxNjIzNDAwLTEwNzAxOTM0ODItMjk1MDA4NTkxMi00NDYyNTU0Mzk',
        'uniqueName': ''
      }
    ],
    'executionOrder': 1,
    'instructions': 'Approval for NonPRD Deployment',
    'blockedApprovers': [
      
    ],
    'minRequiredApprovers': 0,
    'requesterCannotBeApprover': false
  },
  'resource': {
    'type': 'environment',
    'id': '$($nonprdENVOUT.ID)',
    'name': '$($nonprdENVOUT.NAME)'
  },
  'timeout': 10080
}"
    $appro = Invoke-RestMethod -Method Post -Uri $aurl -Headers $Auth -Body $devjson -ContentType 'application/json'
}catch{}
try{
    $prdENVOUT = Invoke-RestMethod -Method Post -Uri $uri -Headers $Auth -Body $prdenvbody -ContentType 'application/json'
    $sdevjson = "{
  'type': {
    'id': '8C6F20A7-A545-4486-9777-F762FAFE0D4D',
    'name': 'Approval'
  },
  'settings': {
    'approvers': [
      {
        'displayName': '[Cloud Integration]\\Senior Developers',
        'id': '8dd01a99-c8a5-47e5-a684-d98dda6bd8b9',
        'descriptor': 'vssgp.Uy0xLTktMTU1MTM3NDI0NS00MDMwMDI5MDM2LTQxMzAwMDUyNi0yMTc2NDI1Njc3LTE2MzE3Mzc3MTgtMS0yMTEyMjI2NzQ4LTM0MTExMDMzMDQtMjcwNTgwMzM3OC0zOTk3OTQ1MTY1',
        'imageUrl': '/LyondellBasell/_apis/GraphProfile/MemberAvatars/vssgp.Uy0xLTktMTU1MTM3NDI0NS00MDMwMDI5MDM2LTQxMzAwMDUyNi0yMTc2NDI1Njc3LTE2MzE3Mzc3MTgtMS0yMTEyMjI2NzQ4LTM0MTExMDMzMDQtMjcwNTgwMzM3OC0zOTk3OTQ1MTY1',
        'uniqueName': ''
      }
    ],
    'executionOrder': 1,
    'instructions': 'Approval for Prod Deployment',
    'blockedApprovers': [
      
    ],
    'minRequiredApprovers': 0,
    'requesterCannotBeApprover': false
  },
  'resource': {
    'type': 'environment',
    'id': '$($prdENVOUT.ID)',
    'name': '$($prdENVOUT.NAME)'
  },
  'timeout': 10080
}"
    $appro = Invoke-RestMethod -Method Post -Uri $aurl -Headers $Auth -Body $sdevjson -ContentType 'application/json'

}catch{}


 }


$VariableGroups = Invoke-RestMethod -Method get -Uri $CommonURI -Headers $Auth

$Names = $VariableGroups.value|select name,id



<#UpdateAll Variable Groups



 foreach($entry in $Names|sort -Property id){

 $Name = $entry.name -replace "var-lc-",$1
 $GroupID=$entry.id
  $CommonURI = "https://dev.azure.com/LyondellBasell/Cloud Integration/_apis/distributedtask/variablegroups/$($GroupID)?api-version=6.0-preview.2"
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
        'rg-systemapp-dev': {
            'isSecret': false,
            'value': 'rg-integration-systemapp-dev'
        },
        'rg-systemapp-nonprd': {
            'isSecret': false,
            'value': 'rg-integration-systemapp-nonprd'
        },
        'rg-systemapp-prd': {
            'isSecret': false,
            'value': 'rg-integration-systemapp-prd'
        },
        'funapp-dev': {
            'isSecret': false,
            'value': 'azfun-$Name-dev'
        },
        'funapp-nonprd': {
            'isSecret': false,
            'value': 'azfun-$Name-nonprd'
        },
        'funapp-prd': {
            'isSecret': false,
            'value': 'azfun-$name-prd'
        },
        'rg-prd': {
            'isSecret': false,
            'value': 'rg-$Name-prd'
        },
        'repo-name': {
            'isSecret': false,
            'value': 'rg-$Name'
        },
        'build-name': {
            'isSecret': false,
            'value': '_rg-$Name'
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

 #>