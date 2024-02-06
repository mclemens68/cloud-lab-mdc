# Get the DNS zone
data "aws_route53_zone" "zone" {
  provider     = aws.route53
  name         = "segmentationpov.com"
  private_zone = false
}

# Add DNS for public and private IPs
resource "aws_route53_record" "ec2_public_dns" {
  provider   = aws.route53
  for_each   = { for k, v in local.config.ec2Instances : k => v if v.publicIP }
  zone_id    = data.aws_route53_zone.zone.zone_id
  name       = "${each.key}"
  type       = "A"
  ttl        = "30"
  records    = [aws_instance.ec2s[each.key].public_ip]
}

resource "aws_route53_record" "ec2_private_dns" {
  provider   = aws.route53
  for_each = local.config.ec2Instances
  zone_id  = data.aws_route53_zone.zone.zone_id
  name     = "${each.key}-priv"
  type     = "A"
  ttl      = "30"
  records  = [aws_instance.ec2s[each.key].private_ip]
}
