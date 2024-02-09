# Virtual Machines
resource "azurerm_linux_virtual_machine" "linuxVMs" {
  for_each            = local.azure_config.linuxVMs
  name                = each.key
  location            = local.azure_config.location
  resource_group_name = local.azure_config.resourceGroup
  network_interface_ids = [
    azurerm_network_interface.vminterfaces[each.key].id,
  ]

  size           = each.value["size"]
  admin_username = "centos"

  admin_ssh_key {
    username   = "centos"
    public_key = file(local.aws_config.public_sshkey) # Replace with your SSH public key path
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9"
    version   = "latest"
  }
  tags = each.value.tags
}

# Network Interfaces for VMs
resource "azurerm_network_interface" "vminterfaces" {
  for_each            = local.azure_config.linuxVMs
  name                = each.key
  location            = local.azure_config.location
  resource_group_name = local.azure_config.resourceGroup

  ip_configuration {
    name                          = each.key
    subnet_id                     = azurerm_subnet.subnets["${each.value["vnet"]}.${each.value["subnet"]}"].id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_network_security_group" "baseline" {
  name                = "baseline"
  location            = local.azure_config.location
  resource_group_name = local.azure_config.resourceGroup

  security_rule {
    name                       = "test123"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes =   ["10.0.0.0/8", "192.168.0.0/16"]
    destination_address_prefixes =  ["10.0.0.0/8", "192.168.0.0/16"]
  }
}

resource "azurerm_network_interface_security_group_association" "baseline" {
  for_each = local.azure_config.linuxVMs 
  network_interface_id      = azurerm_network_interface.vminterfaces[each.key].id
  network_security_group_id = azurerm_network_security_group.baseline.id
}


resource "azurerm_storage_account" "storage" {
  name                = "se32terraformflowlogs"
  resource_group_name = local.azure_config.resourceGroup
  location            = local.azure_config.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_network_watcher_flow_log" "nw_flog" {
  network_watcher_name = "NetworkWatcher_eastus"
  resource_group_name  = "NetworkWatcherRG"
  name                 = "baseline-log"

  network_security_group_id = azurerm_network_security_group.baseline.id
  storage_account_id        = azurerm_storage_account.storage.id
  enabled                   = true
  version = 2

  retention_policy {
    enabled = true
    days    = 7
  }
}