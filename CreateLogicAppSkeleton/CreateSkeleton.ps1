Connect-AzAccount -Subscription lyb-nonprd
$rg = 'rg-integration-jostinbound-dev'
$app = 'lapp-jostinbound-messagess'
$VerbosePreference = 'Continue'

$logicapp = Get-AzResource -ResourceGroupName $RG -ResourceType Microsoft.Logic/workflows -ResourceName "$App"
$LatestRun = Get-AzLogicAppRunHistory -ResourceGroupName $rg -Name $app |select -First 1
$TriggerAction = Get-AzLogicAppTriggerHistory -ResourceGroupName $rg -Name $app -HistoryName $LatestRun.Name -TriggerName $LatestRun.Trigger.Name -Verbose
$RunAction = (Get-AzLogicAppRunAction -ResourceGroupName "$RG" -Name "$App" -RunName $LatestRun.Name)|sort -Property "StartTime","EndTime"|select 'Name','Status','Code','StartTime','EndTime'

$def = $logicapp.Properties.definition

$actions = $def.actions

class Node{
    [String]$Name
    [String]$Status
    [String]$Code
    [Datetime]$StartTime
    [Datetime]$EndTime
    [Node]$SubTree
    [Node[]]$NextNodes
    [String[]]$ParentStatus
    
}

function FindParentNode{
param($actions)
    
    $LayerItemsP = ($actions|gm -MemberType NoteProperty).Name
    foreach($item in $LayerItemsP){

        if(($actions.$item.runAfter|gm -MemberType NoteProperty).count -eq 0){
            $NodeObj = New-Object Node -Property @{Name = $item; ParentStatus ='Initial'}
            return $NodeObj
        }
    }

}

function FindNextNodes{
    param($action,$CurrentNode)
    $Name  = $currentnode.name
    $LayerItems = ($actions|gm -MemberType NoteProperty).Name|where {$_ -ne $Name}
    $Nodes =  @()
    foreach($item in $LayerItems){
        if(($action.$item.runAfter|select $Name).$Name){
            $Nodes += New-Object Node -Property @{Name = $item; Parentstatus = $action.$item.runAfter.$Name }
        }
    }
    return $Nodes
}

function RecurseAttach{
    param($actions,$Parent)
    $NextNodes = FindNextNodes -action $actions -CurrentNode $Parent
    $parent.NextNodes = $NextNodes
    
    Write-Verbose ($Parent|Out-String)
    if($parent.NextNodes -eq $null){return $null}

    foreach($node in $parent.NextNodes){
        $NodeName = $node.Name
        if(($actions.$NodeName|gm -MemberType NoteProperty).Name -contains 'actions'){
            
            $InternalParent = FindParentNode -actions $actions.$NodeName.actions
            $InternalTree = RecurseAttach -actions $actions.$NodeName.actions -Parent $InternalParent
            $($parent.NextNodes|where{$_.name -eq $NodeName}).SubTree = $InternalTree
        }
        try{
            $parent.NextNodes.nextNodes = RecurseAttach -actions $actions -Parent $node 
        }
        catch{}
    }
    return $Parent
}


$root = FindParentNode -actions $actions

$LogicAppStructure = RecurseAttach -actions $actions -Parent $root




$LogicAppStructure