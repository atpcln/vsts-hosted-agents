# Name of the resource group
$resourceGroupName = 'vsts-private-agent-rg'
# Resource Group Location 
$resourceGroupLocation = 'South Central US' # Run <Get-AzureLocation> to find out azure locations; EXAMPLE: 'East US 2'
# vNet to apply NSG
$vnetName = 'VNet01'
# Name of the NSG
$subnetName = 'Subnet-1'

# Create the NSG Rules to be added to the NSG Group (Allow RDP)
$nsgRule1 = New-AzureRmNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 `
-SourceAddressPrefix Internet -SourcePortRange * `
-DestinationAddressPrefix * -DestinationPortRange 3389

# Create the Network Security Group and associate the rule
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -Name "vstsPrivateAgent-NSG" -SecurityRules $nsgRule1

# Create vNet object
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName

# Create Subnet cofnig with NSG
Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnetName -AddressPrefix 10.0.0.0/24 -NetworkSecurityGroup $nsg
# Save the vNet setting
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet