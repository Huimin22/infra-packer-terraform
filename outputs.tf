output "ubuntu_ips" {
  description = "Ubuntu instance IP"
  value       = aws_instance.private_ubuntu_instances[*].private_ip
}

output "amazon_linux_ips" {
  description = "Amazon Linux instances IP"
  value       = aws_instance.private_amazon_linux_instances[*].private_ip
}

output "my_vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}
