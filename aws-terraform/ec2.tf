data "aws_ami" "amis" {
  for_each    = local.config.amis
  owners      = [each.value["owner"]]
  most_recent = true
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = [each.value["ami"]]
  }
}

resource "aws_instance" "ec2s" {
  for_each                    = local.config.ec2Instances
  ami                         = data.aws_ami.amis[each.value["ami"]].id
  instance_type               = each.value["type"]
  subnet_id                   = aws_subnet.subnets[each.value["subnet"]].id
  vpc_security_group_ids      = [aws_security_group.base[each.value["vpc"]].id]
  associate_public_ip_address = each.value["publicIP"]
  key_name                    = each.value["vpc"]
  root_block_device {
    delete_on_termination = true
    volume_size           = each.value["volSizeGb"]
  }
  lifecycle {
    ignore_changes = [user_data, ami]
  }
  tags = merge(each.value.tags, {Name = each.key})
}