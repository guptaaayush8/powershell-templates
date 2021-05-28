$Files = (dir .\xmls -Filter "*.xml").FullName
$Data = @()
foreach($File in $Files){
$content = [xml](gc $File) 

$policyName = $content.brl.ruleset.name
$Rules  = $content.brl.ruleset.rule


foreach($Rule in $Rules){
    $Row = ""|select PolicyName,RuleName,RulePriority,AssignToType,AssignToValue,AssignFromType,AssignFromValue,FunLookupType,FromLookupTypeName,FuncLookupType,ToLookupTypeName,FromCodeType,FromCode,SQL
    $row.PolicyName = $policyName
    $row.RuleName = $rule.name
    $row.RulePriority = $rule.priority
    if($Rule.then.function.classmember.member -eq 'SetDerivedFact'){
        $row.AssignToType = 'Hash' 
        $row.AssignToValue = $Rule.then.function.classmember.argument.constant.string
        $row.AssignFromType = $Rule.then.function.classmember.argument[1].function.datarowmember.column
        $row.FromCodeType = (($rule.if.and.compare|where{$_.lhs.function.datarowmember.column -eq 'FromCode'}).rhs|gm -MemberType Property).Name
        if($row.FromCodeType -eq 'constant'){
            $row.FromCode = ($rule.if.and.compare|where{$_.lhs.function.datarowmember.column -eq 'FromCode'}).rhs.constant.string
        }
        else{
            $row.FromCodeType = 'Hash'
            $row.FromCode = ($rule.if.and.compare|where{$_.lhs.function.datarowmember.column -eq 'FromCode'}).rhs.function.classmember.argument.constant.string
        }
    }
    elseif(($Rule.then.function|gm -MemberType Property).Name -eq 'xmldocumentmember'){
        $row.AssignToType = 'Xpath' 
        $row.AssignToValue = "\\*\" + $Rule.then.function.xmldocumentmember.field
        $row.AssignFromType = $Rule.then.function.xmldocumentmember.argument.function.datarowmember.column
        $row.FromCodeType = (($rule.if.and.compare|where{$_.lhs.function.datarowmember.column -eq 'FromCode'}).rhs|gm -MemberType Property).Name
        $row.FromCodeType = 'Xpath'
        $row.FromCode = "\\*\" +($rule.if.and.compare|where{$_.lhs.function.datarowmember.column -eq 'FromCode'}).rhs.function.xmldocumentmember.field
        
    }

    $row.FunLookupType = (($rule.if.and.compare|where{$_.lhs.function.datarowmember.column -eq 'FromLookupTypeName'}).rhs|gm -MemberType Property).Name
    if($row.FunLookupType -eq 'constant'){
        $row.FromLookupTypeName = ($rule.if.and.compare|where{$_.lhs.function.datarowmember.column -eq 'FromLookupTypeName'}).rhs.constant.string
    }
    else{
        $row.FunLookupType = 'Hash'
        $row.FromLookupTypeName = ($rule.if.and.compare|where{$_.lhs.function.datarowmember.column -eq 'FromLookupTypeName'}).rhs.function.classmember.argument.constant.string
    }
   
    $row.FuncLookupType = (($rule.if.and.compare|where{$_.lhs.function.datarowmember.column -eq 'ToLookupTypeName'}).rhs|gm -MemberType Property).Name
    if($row.FuncLookupType -eq 'constant'){
        $row.ToLookupTypeName = ($rule.if.and.compare|where{$_.lhs.function.datarowmember.column -eq 'ToLookupTypeName'}).rhs.constant.string
    }
    else{
        $row.FuncLookupType = 'Hash'
        $row.ToLookupTypeName = ($rule.if.and.compare|where{$_.lhs.function.datarowmember.column -eq 'ToLookupTypeName'}).rhs.function.classmember.argument.constant.string
    }

    

    $row.SQL = "EXEC [dbo].[usp_BatchInsertBREPolicies] @PolicyName = N'$($Row.PolicyName)', @RuleName = N'$($Row.RuleName)', @RulePriority = $($Row.RulePriority), @TypeAssignTo = N'$($Row.AssignToType)', @ValueAssignTo = N'$($Row.AssignToValue)', @TypeAssignFrom = N'$($Row.AssignFromType)', @ValueAssignFrom = N'$($Row.AssignFromValue)', @FromLookupType = N'$($Row.FunLookupType)', @FromLookupValue = N'$($Row.FromLookupTypeName)', @ToLookupType = N'$($Row.FuncLookupType)', @ToLookupValue = N'$($Row.ToLookupTypeName)', @FromCodeType = N'$($row.FromCodeType)', @FromCodeValue = N'$($row.FromCode)', @ToCodeType = N' ', @ToCodeValue = N' ', @ActionLHS = N' ', @ValueLHS = N' ', @ActionRHS = N' ', @ValueRHS = N' '"
    $Data+= $Row
}
}  



