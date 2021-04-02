#Set some parameters, including the PAT (Personal Access Token) from Azure DevOps

Param (
    [string]$azureDevOpsAccount = "acccount",
    [string]$projectName = "project",
    [string]$workItemType = "Feature",
    [string]$buildNumber = "",
    [string]$keepForever = "true",
    [string]$user = "user",
    [string]$token = "token"
)

#Build the array of tasks
$tasks = @("Task 1","Task 2")

#Iterate over the array
foreach ($task in $tasks)
{
    #Build the JSON body (NOTE: The WorkItem ID needs to be changed in the 'url' property to match the parent WorkItem getting the new tasks. The 'AssignedTo' needs to be validated as well.)
    $body = @"
    [
        {
        "op": "add",
        "path": "/fields/System.Title",
        "from": null,
        "value": "$task"
        },
        {
        "op": "add",
        "path": "/relations/-",
        "value": {
            "rel": "System.LinkTypes.Hierarchy-Reverse",
            "url": "https://url/DefaultCollection/project/_apis/wit/workItems/53580"
                 },
        },
        {
        "op": "add",
        "path": "/fields/System.AssignedTo",
        "value": "Aayush Gupta"
        }
    ]
"@

    #Required: Convert the PAT to base64
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))

    #Construct the URI
    $uri = "https://dev.azure.com/LyondellBasell/Cloud Integration/_apis/wit/workitems/`$Epic`?api-version=5.0"

    #Invoke a REST API call for each task to be created
    $result = Invoke-RestMethod -Uri $uri -Method Patch -ContentType "application/json-patch+json" -Headers $Auth -Body $body
    $result | ConvertTo-Json
}