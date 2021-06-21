function DeployProjContent{
    param($Names)
    $ContentCollection = @()
    foreach($Name in $Names){
        $ContentCollection += "<Content Include = '$Name'/>"    
    }
    return $ContentCollection -join "`n"
}
function CreateContentParameters{
    param($InputArr)
    $ReturnArr = @()

    foreach($Item in $InputArr){
        $ReturnArr+= "$Item.json"
        $ReturnArr+= "parameters\$Item.parameters.DEV.json"
        $ReturnArr+= "parameters\$Item.parameters.STG.json"
        $ReturnArr+= "parameters\$Item.parameters.PRD.json"
    }
    return $ReturnArr
}
function CreateSolnFiles{
param(
    $ProjectName,
    $LappJSONS,
    $Location = ".\OutPutSoln"
)
    
    $ContentFiles = CreateContentParameters -InputArr $LappJSONS

    $SLNGuid = (New-Guid).Guid.toupper()
    $DeployProjGuid = (New-Guid).Guid.toupper()
    $DeployProj = (gc .\config\SolutionFiles\DeployProj.txt) -replace '%LAPP%',$DeployProjGuid -replace '%GUID%',$SLNGuid -replace '%CONTENT%',(DeployProjContent -Names $ContentFiles)
    $SolnFile = (gc .\config\SolutionFiles\SolutionFile.txt) -replace '%LAPP%',$DeployProjGuid -replace '%GUID%',$SLNGuid

    mkdir "$Location\$ProjectName\logicapp-workflows\parameters"|Out-Null
    $SolnFile|Out-File -FilePath "$Location\$ProjectName\$ProjectName.sln" -Force
    $DeployProj|Out-File -FilePath "$Location\$ProjectName\logicapp-workflows\logicapp-workflows.deployproj" -Force

}
function CombineParameters{
    param(
        $Base,
        $Additive
    )
    foreach($param in ($additive.parameters|gm -MemberType NoteProperty).Name){
    try{
        $Base.parameters|Add-Member -MemberType NoteProperty -Name $param -Value $Additive.parameters.$param -Force
    }catch{}
    }
    return $Base.parameters|select -Unique
}
function CombineVariables{
    param(
        $Base,
        $Additive
    )
    foreach($Var in ($additive.variables|gm -MemberType NoteProperty).Name){
    try{
        $Base.variables|Add-Member -MemberType NoteProperty -Name $Var -Value $Additive.variables.$Var -Force
    }catch{}
    }
    return $Base.variables|select -Unique
}
function CombineOutputs{
    param(
        $Base,
        $Additive
    )
    try{
    foreach($Var in ($additive.Outputs|gm -MemberType NoteProperty -ErrorAction SilentlyContinue).Name){
    try{
        $Base.outputs|Add-Member -MemberType NoteProperty -Name $Var -Value $Additive.outputs.$Var -Force
    }catch{}
    }}catch{}
    return $Base.outputs|select -Unique
}
function CombineResources{
    param($Base,$Additive)

    $BaseNames = $Base.resources.name
    $AdditiveNames = $Additive.resources.name
    $ResourceObject =@()
    foreach($Name in $AdditiveNames){
        if($BaseNames -contains $Name){
            Write-Verbose $Name
            $AddObject = $Additive.resources|where{$_.name -eq $Name}
            $BaseObject = $Base.resources|where{$_.name -eq $Name}
            $ResourceObject += (CombineObject -BaseObject $BaseObject -AddObject $AddObject)
        }
        else{
        Write-Verbose "Else"
        Write-Verbose $Name
            $ResourceObject += $Additive.resources|where{$_.name -eq $Name}
        }
    }


    foreach($Name in $BaseNames){
        if($ResourceObject.Name -notcontains $Name){
        $ResourceObject += $Base.resources|where{$_.name -eq $Name}
        }
    }
    return $ResourceObject
}
function CombineObject{
    param(
        $BaseObject,$AddObject
    )
    Write-Verbose ($BaseObject|Out-String)
    Write-Verbose ($AddObject|Out-String)
    $BaseMembers = ($BaseObject|gm -MemberType NoteProperty).Name
    $AddMembers = ($AddObject|gm -MemberType NoteProperty).Name
    foreach($Member in $AddMembers){
        if($BaseMembers -notcontains $Member){
            $BaseObject|Add-Member -MemberType NoteProperty -Name $Member -Value $AddObject.$Member
        }
        else{

            if($Baseobject.$Member.GetType().Name -eq 'String'){
                $BaseObject.$Member =  ($BaseObject.$Member,$AddObject.$Member|select -Unique)
            }
            elseif($Baseobject.$Member.GetType().Name -match 'Object\[\]'){
                $BaseObject.$Member =  ($BaseObject.$Member+$AddObject.$Member|select -Unique)
            }
            else{
                $BaseObject.$Member =  (CombineObject $BaseObject.$Member $AddObject.$Member)
            }
        }
    }
    return $BaseObject
}
function CombineJSONS {
    param(
        $Base,
        $Additive
    )
   
    $Base.variables =  CombineVariables -Base $Base -Additive $Additive
    $Base.parameters = CombineParameters -Base $Base -Additive $Additive
    $Base.outputs =    CombineOutputs -Base $Base -Additive $Additive
    $Base.resources =  CombineResources -Base $Base -Additive $Additive

    return $Base
}

$Files = dir -Path .\InputCSV -Filter "*.csv"

foreach($File in $Files){
   $Lapps =  ConvertFrom-Csv (gc $File.FullName)
   $SLNNames = $Lapps.RepoName|select -Unique
   foreach($SLNName in $SLNNames){
        $LappJSONS = ($Lapps|? {$_.RepoName -eq $SLNName})
        CreateSolnFiles -ProjectName $SLNName -LappJSONS $LappJSONS.FileName
        foreach($lapp in $LappJSONS){
            
            $Base = gc .\Config\BaseLappFile\CommonARM.json |ConvertFrom-Json
            
            #InboundPort
            if($lapp.InboundPort -ne $null){
               try{$Additive = gc ".\Config\InboundPort\$($lapp.inboundport).json"|ConvertFrom-Json
               $Base = CombineJSONS -Base $Base -Additive $Additive
               }catch{}
            }
            #OutBound
            if($lapp.Outbound -ne $null){
               try{
                    $Additive = gc ".\Config\OutBound\$($lapp.Outbound).json"|ConvertFrom-Json
                    $Base = CombineJSONS -Base $Base -Additive $Additive
               }catch{}
            }
            #Backup
            if($lapp.Backup.ToUpper() -eq 'Yes'){
               try{$Additive = gc ".\Config\Backup\Backup.json"|ConvertFrom-Json
               $Base = CombineJSONS -Base $Base -Additive $Additive
               }catch{}
            }

            $Base|ConvertTo-Json -Depth 99 |Out-File -FilePath ".\OutPutSoln\$SLNName\logicapp-workflows\$($lapp.FileName).json"

        }
   }
}




