#Deployment Check 

$RG = 'rg-integration-excisetax813-dev' ## $(rg-dev)


$Collection = ([xml](gc .\DeploymentCollection.xml)).Collection.Resources



$resource = Get-AzResource -ResourceGroupName $Collection.ResourceGroup  -Name $collection.Resource.Name -ResourceType $Collection.Resource.ResourceType

$Queue = Get-AzServiceBusQueue -ResourceGroupName rg-integration-systemapp-dev -Namespace sb-integration-lyb-dev

$Topics = Get-AzServiceBusTopic -ResourceGroupName rg-integration-systemapp-dev -Namespace sb-integration-lyb-dev 

$Subs = Get-AzServiceBusSubscription -ResourceGroupName rg-integration-systemapp-dev -Namespace sb-integration-lyb-dev -Topic sbt-cmn-publish










