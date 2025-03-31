//vpc setup
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "MyVPC"
    cidr = "10.0.0.0/16"

    azs  = ["us-east-1a", "us-east-1b"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
 

// Single NAT for all AZ
    enable_nat_gateway      = true
    single_nat_gateway      = true
    one_nat_gateway_per_az  = false
    reuse_nat_ips           = true
    external_nat_ip_ids     = aws_eip.nat.*.id

    enable_dns_hostnames = true
}

resource "aws_eip" "nat" {
  count = 1
  domain = "vpc"
}


//security_group 
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH from my IP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]  # Only allow SSH from your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_ec2_sg" {
  name        = "private-ec2-security-group"
  description = "Allow SSH from Bastion Host"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}
