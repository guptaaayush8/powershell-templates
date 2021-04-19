
$files=$(git diff HEAD~1 HEAD --name-only)|where {$_.startswith('Release-Pipelines')}

Write-Host "Total Modified Release Pipelines Found : $($files.Count)"

if($files.Count -eq 0){
    Write-Host "No Pipelines Modified skipping Build"
    exit 0;
}

$LYBPAT = '3umjnantc74nqtzgl44726j7yccciuhoadffvpw6d564pjjxe4hq'

$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($LYBPAT)")) }



foreach($file in $files){
    
    "Getting Revision of Pipeline $file"
    $pipelineID = (gc $file|ConvertFrom-Json).id
    $PipelineURL = "https://vsrm.dev.azure.com/LyondellBasell/Cloud Integration/_apis/release/definitions/$($pipelineID)?api-version=6.0"
    $Rev = (Invoke-RestMethod -method Get -Headers $AzureDevOpsAuthenicationHeader -Uri $PipelineURL).revision

    "Updating Pipeline ' $file '"
    $jsonBody = (gc $file) -replace '%REVISION%',$Rev 
    try{
        $out = Invoke-RestMethod -method Put -Headers $AzureDevOpsAuthenicationHeader -body $jsonBody -Uri $url -ContentType "application/json"
    }catch{
        $_.exception
    }
}     
