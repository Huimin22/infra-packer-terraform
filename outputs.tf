output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_eip.bastion_eip.public_ip
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_ec2_private_ips" {
  description = "Private IPs of the private EC2 instances"
  value       = aws_instance.private_ec2[*].private_ip
}
