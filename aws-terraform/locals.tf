# This locals creates a map with the vpc name as the key and the value is the list of subnet IDs.
# This is used in the transit gateway to attach the subnets
locals {
  config = yamldecode(file("${path.module}/${var.config}"))

  subnet_ids_by_vpc = {
    for vpc_key, _ in local.config.vpcs : vpc_key => [
      for subnet_key, _ in local.config.vpcs[vpc_key].subnets : aws_subnet.subnets["${vpc_key}.${subnet_key}"].id
    ]
  }

  subnet_ids_by_name = merge([
    for vpc_name, vpc_config in local.config.vpcs : {
      for subnet_name, subnet_cidr in vpc_config.subnets : 
        "${vpc_name}.${subnet_name}" => subnet_cidr
    }
  ]...)

   # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  vpc_subnets = flatten([
    for vpc_name, vpc in local.config.vpcs : [
      for subnet_key, subnet in vpc.subnets : {
        vpc_name = vpc_name
        subnet_key  = subnet_key
        subnet_name = "${vpc_name}.${subnet_key}"
        vpc_id  = aws_vpc.vpcs[vpc_name].id
        cidr_block  = subnet["cidrBlock"]
        public = subnet["public"]
        az = "${local.config.region}${subnet["az"]}"
      }
    ]
  ])
}