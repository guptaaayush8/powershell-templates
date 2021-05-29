
function CombineObject{
    param(
        $Base,
        $Additive
    )

    $AdditiveMembers = ($Additive|gm -MemberType NoteProperty).Name
    $BaseMembers = ($Base|gm -MemberType NoteProperty).Name
    foreach($AdditiveMember in $AdditiveMembers){
        if($BaseMembers -notcontains $AdditiveMember){
            $Base|Add-Member -MemberType NoteProperty -Name $AdditiveMember -Value $Additive.$AdditiveMember -Force
        }
        else{
           $Base|Add-Member -MemberType NoteProperty -Name $AdditiveMember -Value (CombineObject -Base $Base.$AdditiveMember -Additive $Additive.$AdditiveMember) -Force
        }
    }
    return $Base
}