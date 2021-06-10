
$Base = gc .\CommonARM.json|ConvertFrom-Json
$Additive = gc .\resources\sftp.json|ConvertFrom-Json

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

$base.variables =  CombineVariables -Base $base -Additive $additive
$base.parameters = CombineParameters -Base $base -Additive $additive
$base.outputs =    CombineOutputs -Base $base -Additive $additive
$base.resources =  CombineResources -Base $Base -Additive $Additive