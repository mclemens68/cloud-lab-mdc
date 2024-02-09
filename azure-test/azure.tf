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
  name                 = each.key
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = each.value["vnet_name"]
  address_prefixes     = [each.value["address_space"]]
}

# Virtual Machines
resource "azurerm_linux_virtual_machine" "linuxVMs" {
for_each                    = local.azure_config.linuxVMs
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
    public_key = file("~/.ssh/id_rsa.pub") # Replace with your SSH public key path
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
}

# Network Interfaces for VMs
resource "azurerm_network_interface" "vminterfaces" {
for_each                    = local.azure_config.linuxVMs
  name                = each.key
  location            = local.azure_config.location
  resource_group_name = local.azure_config.resourceGroup

  ip_configuration {
    name                          = each.key
    subnet_id                     = azurerm_subnet.subnets[each.value["subnet"]].id
    private_ip_address_allocation = "Dynamic"
  }
}
