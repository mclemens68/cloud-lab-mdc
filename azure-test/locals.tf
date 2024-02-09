# This locals creates a map with the vpc name as the key and the value is the list of subnet IDs.
# This is used in the transit gateway to attach the subnets
locals {
  azure_config = yamldecode(file("${path.module}/${var.azure_config}"))

  vnet_subnets = flatten([
    for vnet_name, vnet in local.azure_config.vnets : [
      for subnet_key, subnet in vnet.subnets : {
        vnet_name = vnet_name
        subnet_key  = subnet_key
        subnet_name = "${vnet_name}.${subnet_key}"
        vnet_id  = azurerm_virtual_network.vnets[vnet_name].id
        address_space  = subnet["addressSpace"]
      }
    ]
  ])
}