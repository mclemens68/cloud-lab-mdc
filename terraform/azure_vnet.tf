# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.azure_config.resourceGroup
  location = local.azure_config.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnets" {
  for_each            = local.azure_config.vnets
  name                = each.key
  address_space       = [each.value["addressSpace"]]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnets" {
  for_each = {
    for subnet in local.vnet_subnets : "${subnet.vnet_name}.${subnet.subnet_key}" => subnet
  }
  name                 = each.value["subnet_key"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = each.value["vnet_name"]
  address_prefixes     = [each.value["address_space"]]
}




resource "azurerm_virtual_network_peering" "vnets_peering-1" {
  for_each                     = local.azure_config.vnetPairings
  name                         = "${each.key}-1"
  resource_group_name          = local.azure_config.resourceGroup
  virtual_network_name         = each.value[1]
  remote_virtual_network_id    = azurerm_virtual_network.vnets[each.value[0]].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "vnets_peering-2" {
  for_each                     = local.azure_config.vnetPairings
  name                         = "${each.key}-2"
  resource_group_name          = local.azure_config.resourceGroup
  virtual_network_name         = each.value[0]
  remote_virtual_network_id    = azurerm_virtual_network.vnets[each.value[1]].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}