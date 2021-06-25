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
        $BaseTmp,
        $AdditiveTmp
    )
    foreach($param in ($AdditiveTmp.parameters|gm -MemberType NoteProperty).Name){
    try{
        $BaseTmp.parameters|Add-Member -MemberType NoteProperty -Name $param -Value $AdditiveTmp.parameters.$param -Force
    }catch{}
    }
    return $BaseTmp.parameters|select -Unique
}
function CombineVariables{
    param(
        $BaseTmp,
        $AdditiveTmp
    )
    foreach($Var in ($AdditiveTmp.variables|gm -MemberType NoteProperty).Name){
    try{
        $BaseTmp.variables|Add-Member -MemberType NoteProperty -Name $Var -Value $AdditiveTmp.variables.$Var -Force
    }catch{}
    }
    return $BaseTmp.variables|select -Unique
}
function CombineOutputs{
    param(
        $BaseTmp,
        $AdditiveTmp
    )
    try{
    foreach($Var in ($AdditiveTmp.Outputs|gm -MemberType NoteProperty -ErrorAction SilentlyContinue).Name){
    try{
        $BaseTmp.outputs|Add-Member -MemberType NoteProperty -Name $Var -Value $AdditiveTmp.outputs.$Var -Force
    }catch{}
    }}catch{}
    return $BaseTmp.outputs|select -Unique
}
function CombineResources{
    param($BaseTmp,$AdditiveTmp)

    $BaseTmpNames = $BaseTmp.resources.name
    $AdditiveTmpNames = $AdditiveTmp.resources.name
    $ResourceObject =@()
    foreach($Name in $AdditiveTmpNames){
        if($BaseTmpNames -contains $Name){
            Write-Verbose $Name
            $AddObject = $AdditiveTmp.resources|where{$_.name -eq $Name}
            $BaseTmpObject = $BaseTmp.resources|where{$_.name -eq $Name}
            $ResourceObject += (CombineObject -BaseTmpObject $BaseTmpObject -AddObject $AddObject)
        }
        else{
        Write-Verbose "Else"
        Write-Verbose $Name
            $ResourceObject += $AdditiveTmp.resources|where{$_.name -eq $Name}
        }
    }


    foreach($Name in $BaseTmpNames){
        if($ResourceObject.Name -notcontains $Name){
        $ResourceObject += $BaseTmp.resources|where{$_.name -eq $Name}
        }
    }
    return $ResourceObject
}
function CombineObject{
    param(
        $BaseTmpObject,$AddObject
    )
    Write-Verbose ($BaseTmpObject|Out-String)
    Write-Verbose ($AddObject|Out-String)
    $BaseTmpMembers = ($BaseTmpObject|gm -MemberType NoteProperty).Name
    $AddMembers = ($AddObject|gm -MemberType NoteProperty).Name
    foreach($Member in $AddMembers){
        if($BaseTmpMembers -notcontains $Member){
            $BaseTmpObject|Add-Member -MemberType NoteProperty -Name $Member -Value $AddObject.$Member
        }
        else{

            if($BaseTmpobject.$Member.GetType().Name -eq 'String'){
                $BaseTmpObject.$Member =  ($BaseTmpObject.$Member,$AddObject.$Member|select -Unique)
            }
            elseif($BaseTmpobject.$Member.GetType().Name -match 'Object\[\]'){
                $BaseTmpObject.$Member =  ($BaseTmpObject.$Member+$AddObject.$Member|select -Unique)
            }
            else{
                $BaseTmpObject.$Member =  (CombineObject $BaseTmpObject.$Member $AddObject.$Member)
            }
        }
    }
    return $BaseTmpObject
}
function CombineJSONS {
    param(
        $BaseTmp,
        $AdditiveTmp
    )
   
    $BaseTmp.variables =  CombineVariables -BaseTmp $BaseTmp -AdditiveTmp $AdditiveTmp
    $BaseTmp.parameters = CombineParameters -BaseTmp $BaseTmp -AdditiveTmp $AdditiveTmp
    $BaseTmp.outputs =    CombineOutputs -BaseTmp $BaseTmp -AdditiveTmp $AdditiveTmp
    $BaseTmp.resources =  CombineResources -BaseTmp $BaseTmp -AdditiveTmp $AdditiveTmp

    return $BaseTmp
}

$Files = dir -Path .\InputCSV -Filter "*.csv"

foreach($File in $Files){
   $Lapps =  ConvertFrom-Csv (gc $File.FullName)
   $SLNNames = $Lapps.RepoName|select -Unique
   foreach($SLNName in $SLNNames){
        $LappJSONS = ($Lapps|? {$_.RepoName -eq $SLNName})
        CreateSolnFiles -ProjectName $SLNName -LappJSONS $LappJSONS.FileName
        foreach($lapp in $LappJSONS){
            
            $BaseTmp = gc .\Config\BaseLappFile\CommonARM.json |ConvertFrom-Json
            $BaseParamDEV = gc .\Config\BaseLappFile\CommonARMParamDEV.json |ConvertFrom-Json
            $BaseParamSTG = gc .\Config\BaseLappFile\CommonARMParamSTG.json |ConvertFrom-Json
            $BaseParamPRD = gc .\Config\BaseLappFile\CommonARMParamPRD.json |ConvertFrom-Json
            #InboundPort
            if($lapp.InboundPort -ne $null){
               try{
               $AdditiveTmp = gc ".\Config\InboundPort\$($lapp.inboundport)\template.json"|ConvertFrom-Json
               $AdditiveParamDEV = gc ".\Config\InboundPort\$($lapp.InboundPort)\paramDEV.json"|ConvertFrom-Json
               $AdditiveParamSTG = gc ".\Config\InboundPort\$($lapp.InboundPort)\paramSTG.json"|ConvertFrom-Json
               $AdditiveParamPRD = gc ".\Config\InboundPort\$($lapp.InboundPort)\paramPRD.json"|ConvertFrom-Json
               $BaseTmp = CombineJSONS -BaseTmp $BaseTmp -AdditiveTmp $AdditiveTmp
               $BaseParamDEV = CombineObject -BaseTmpObject $BaseParamDEV -AddObject $AdditiveParamDEV
               $BaseParamSTG = CombineObject -BaseTmpObject $BaseParamSTG -AddObject $AdditiveParamSTG
               $BaseParamPRD = CombineObject -BaseTmpObject $BaseParamPRD -AddObject $AdditiveParamPRD
               }catch{}
            }
            #OutBound
            if($lapp.Outbound -ne $null){
               try{
                    $AdditiveTmp = gc ".\Config\OutBound\$($lapp.Outbound)\template.json"|ConvertFrom-Json
                    $AdditiveParamDEV = gc ".\Config\OutBound\$($lapp.Outbound)\paramDEV.json"|ConvertFrom-Json
                    $AdditiveParamSTG = gc ".\Config\OutBound\$($lapp.Outbound)\paramSTG.json"|ConvertFrom-Json
                    $AdditiveParamPRD = gc ".\Config\OutBound\$($lapp.Outbound)\paramPRD.json"|ConvertFrom-Json
                    $BaseTmp = CombineJSONS -BaseTmp $BaseTmp -AdditiveTmp $AdditiveTmp
                    $BaseParamDEV = CombineObject -BaseTmpObject $BaseParamDEV -AddObject $AdditiveParamDEV
                    $BaseParamSTG = CombineObject -BaseTmpObject $BaseParamSTG -AddObject $AdditiveParamSTG
                    $BaseParamPRD = CombineObject -BaseTmpObject $BaseParamPRD -AddObject $AdditiveParamPRD
               }catch{}
            }
            #Backup
            if($lapp.Backup -eq 'Yes'){
               try{
               $AdditiveTmp = gc ".\Config\Backup\Backup\template.json"|ConvertFrom-Json
               $AdditiveParamDEV = gc ".\Config\Backup\Backup\paramDEV.json"|ConvertFrom-Json
               $AdditiveParamSTG = gc ".\Config\Backup\Backup\paramSTG.json"|ConvertFrom-Json
               $AdditiveParamPRD = gc ".\Config\Backup\Backup\paramPRD.json"|ConvertFrom-Json
               $BaseTmp = CombineJSONS -BaseTmp $BaseTmp -AdditiveTmp $AdditiveTmp
               $BaseParamDEV = CombineObject -BaseTmpObject $BaseParamDEV -AddObject $AdditiveParamDEV
               $BaseParamSTG = CombineObject -BaseTmpObject $BaseParamSTG -AddObject $AdditiveParamSTG
               $BaseParamPRD = CombineObject -BaseTmpObject $BaseParamPRD -AddObject $AdditiveParamPRD
               }catch{}
            }

            ($BaseTmp|ConvertTo-Json -Depth 99) -replace '\\u0027','"' |Out-File -FilePath ".\OutPutSoln\$SLNName\logicapp-workflows\$($lapp.FileName).json"
            ($BaseParamDEV|ConvertTo-Json -Depth 99) -replace '\\u0027','"' |Out-File -FilePath ".\OutPutSoln\$SLNName\logicapp-workflows\parameters\$($lapp.FileName).parameters.DEV.json"
            ($BaseParamSTG|ConvertTo-Json -Depth 99) -replace '\\u0027','"' |Out-File -FilePath ".\OutPutSoln\$SLNName\logicapp-workflows\parameters\$($lapp.FileName).parameters.STG.json"
            ($BaseParamPRD|ConvertTo-Json -Depth 99) -replace '\\u0027','"' |Out-File -FilePath ".\OutPutSoln\$SLNName\logicapp-workflows\parameters\$($lapp.FileName).parameters.PRD.json"

        }
   }
}



