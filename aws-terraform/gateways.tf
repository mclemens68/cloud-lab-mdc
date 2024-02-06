// Each VPC gets an internet gateway
resource "aws_internet_gateway" "igws" {
  for_each = local.config.vpcs
  vpc_id   = aws_vpc.vpcs[each.key].id
  tags = {
    Name = "${each.key}.igw"
  }
}

// Each VPC gets an elastic IP for the nat gateway
resource "aws_eip" "ngw_eips" {
  for_each = local.config.vpcs
  domain   = "vpc"
  tags = {
    Name = "${each.key}-ngw-eip"
  }
}

// Every public subnet gets a nat gateway - logic assumes only 1 public subnet per VPC
resource "aws_nat_gateway" "ngws" {
  for_each = {
    for subnet in local.vpc_subnets : subnet.vpc_name => subnet if subnet.public
  }
  connectivity_type = "public"
  allocation_id     = aws_eip.ngw_eips[each.value["vpc_name"]].id
  subnet_id         = aws_subnet.subnets[each.value["subnet_name"]].id
  depends_on        = [aws_internet_gateway.igws]
  tags = {
    Name = "${each.value["subnet_name"]}-ngw"
  }
}

// Create 1 transit gateways to connect all the VPCs
resource "aws_ec2_transit_gateway" "tgw" {
  description                    = "transit gateway to connect vpcs"
  dns_support                    = "enable"
  vpn_ecmp_support               = "enable"
  auto_accept_shared_attachments = "enable"
  tags = {
    Name = "tgw01"
  }
}

// Attach the transit gateway to all subnets in the VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-attachment" {
  for_each           = local.config.vpcs
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpcs[each.key].id
  subnet_ids         = [for subnetName, v in local.config.vpcs[each.key].subnets : aws_subnet.subnets["${each.key}.${subnetName}"].id]
}