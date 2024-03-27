resource "azurerm_kubernetes_cluster" "aks" {
  for_each            = local.azure_config.aksClusters
  resource_group_name = local.azure_config.resourceGroup
  location            = local.azure_config.location
  name                = each.key
  dns_prefix          = each.key
  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = each.value["nodeCount"]
    upgrade_settings {
      max_surge = "10%"
    }
  }
  linux_profile {
    admin_username = each.value["adminUserName"]

    ssh_key {
      key_data = file(local.aws_config.public_sshkey)
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}
