param(
    [string]$ProjectName,
    [string[]]$LappJSONS,
    [string]$Location
)



function DeployProjContent{
    param($Names)
    $ContentCollection = @()
    foreach($Name in $Names){
        $ContentCollection += "<Content Include = '$Name'/>"    
    }
    return $ContentCollection -join "`n"
}

$SLNGuid = (New-Guid).Guid.toupper()
$DeployProjGuid = (New-Guid).Guid.toupper()
$DeployProj = (gc .\ProjectFiles\DeployProj.txt) -replace '%LAPP%',$DeployProjGuid -replace '%GUID%',$SLNGuid -replace '%CONTENT%',(DeployProjContent -Names $LappJSONS)
$SolnFile = (gc .\ProjectFiles\SolutionFile.txt) -replace '%LAPP%',$DeployProjGuid -replace '%GUID%',$SLNGuid

mkdir "$Location\$ProjectName\logicapp-workflows"
$SolnFile|Out-File -FilePath "$Location\$ProjectName\$ProjectName.sln" -Force
$DeployProj|Out-File -FilePath "$Location\$ProjectName\logicapp-workflows\logicapp-workflows.deployproj" -Force
 