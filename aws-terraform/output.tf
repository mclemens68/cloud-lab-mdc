output "vpcs" {
  value = { for k, v in aws_vpc.vpcs : k => v.cidr_block }
}
output "ec2_public_ips" {
  value = { for k, v in aws_instance.ec2s : k => v.public_ip if v.public_ip != ""}
}
output "ec2_private_ip" {
  value = { for k, v in aws_instance.ec2s : k => v.private_ip }
}
output "eks_clusters" {
  value = { for k, v in aws_eks_cluster.eks_cluster : k => v.name }
}
output "public_dns" {
  value = { for k, v in aws_route53_record.ec2_public_dns : k => "${v.name}.${data.aws_route53_zone.zone.name}" }
}
output "private_dns" {
  value = { for k, v in aws_route53_record.ec2_private_dns : k => "${v.name}.${data.aws_route53_zone.zone.name}" }
}
# output "rds_instances" {
#     value = { for k, v in aws_db_instance.db_instances : k => v.endpoint }
# }