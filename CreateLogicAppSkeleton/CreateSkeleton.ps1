#Connect-AzureRMAccount -Subscription lyb-nonprd
$rg = 'rg-integration-jostinbound-dev'
$app = 'lapp-jostinbound-messagess'
$VerbosePreference = 'Continue'

$logicapp = Get-AzureRMResource -ResourceGroupName $RG -ResourceType Microsoft.Logic/workflows -ResourceName "$App"
$LatestRun = Get-AzureRMLogicAppRunHistory -ResourceGroupName $rg -Name $app |select -First 1
$TriggerAction = Get-AzureRMLogicAppTriggerHistory -ResourceGroupName $rg -Name $app -HistoryName $LatestRun.Name -TriggerName $LatestRun.Trigger.Name -Verbose
$RunAction = (Get-AzureRMLogicAppRunAction -ResourceGroupName "$RG" -Name "$App" -RunName $LatestRun.Name)|sort -Property "StartTime","EndTime"



$def = $logicapp.Properties.definition

$actions = $def.actions

class Node{
    [String]$Name
    [String]$Status
    [String]$Code
    [String]$StartTime
    [String]$EndTime
   # [pscustomobject]$Error
    [pscustomobject]$Input
    [pscustomobject]$Output
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
    $ParentName = $parent.Name
    $parent.status = ($RunAction|where {$_.Name -eq $ParentName}).status
    $parent.Code = ($RunAction|where {$_.Name -eq $ParentName}).code
    $parent.StartTime = ($RunAction|where {$_.Name -eq $ParentName}).StartTime
    $parent.EndTime = ($RunAction|where {$_.Name -eq $ParentName}).EndTime
   # $parent.Error = ($RunAction|where {$_.Name -eq $ParentName}).Error

    try{
    $parent.Input = Invoke-RestMethod ($RunAction|where {$_.Name -eq $ParentName}).InputsLink.Uri
    }catch{}
    try{
    $parent.Output = Invoke-RestMethod ($RunAction|where {$_.Name -eq $ParentName}).OutputsLink.Uri
    }catch{}

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

