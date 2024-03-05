# This locals creates a map with the vpc name as the key and the value is the list of subnet IDs.
# This is used in the transit gateway to attach the subnets
locals {
  aws_config   = yamldecode(file("${path.module}/${var.aws_config}"))
  azure_config = yamldecode(file("${path.module}/${var.azure_config}"))

  subnet_ids_by_vpc = {
    for vpc_key, _ in local.aws_config.vpcs : vpc_key => [
      for subnet_key, _ in local.aws_config.vpcs[vpc_key].subnets : aws_subnet.subnets["${vpc_key}.${subnet_key}"].id
    ]
  }

  subnet_ids_by_name = merge([
    for vpc_name, vpc_config in local.aws_config.vpcs : {
      for subnet_name, subnet_cidr in vpc_config.subnets :
      "${vpc_name}.${subnet_name}" => subnet_cidr
    }
  ]...)

  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  vpc_subnets = flatten([
    for vpc_name, vpc in local.aws_config.vpcs : [
      for subnet_key, subnet in vpc.subnets : {
        vpc_name    = vpc_name
        subnet_key  = subnet_key
        subnet_name = "${vpc_name}.${subnet_key}"
        vpc_id      = aws_vpc.vpcs[vpc_name].id
        cidr_block  = subnet["cidrBlock"]
        public      = subnet["public"]
        az          = "${local.aws_config.region}${subnet["az"]}"
      }
    ]
  ])

  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  vnet_subnets = flatten([
    for vnet_name, vnet in local.azure_config.vnets : [
      for subnet_key, subnet in vnet.subnets : {
        vnet_name     = vnet_name
        subnet_key    = subnet_key
        subnet_name   = "${vnet_name}.${subnet_key}"
        vnet_id       = azurerm_virtual_network.vnets[vnet_name].id
        address_space = subnet["addressSpace"]
        nsg = subnet["nsg"]
      }
    ]
  ])
}
