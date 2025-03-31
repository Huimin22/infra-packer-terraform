# Define the required Terraform version and AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.46"
    }
  }

  required_version = ">= 1.2.0"
}


provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# Allocate an Elastic IP (EIP) for the NAT Gateway
resource "aws_eip" "nat" {
  count = 1

  domain = "vpc"
}

# Create a Virtual Private Cloud (VPC) using the AWS VPC module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "my-ansible-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = [var.public_subnet_id]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  reuse_nat_ips          = true
  external_nat_ip_ids    = aws_eip.nat.*.id
}

# Ansible security group
resource "aws_security_group" "ansible-sg" {
  name   = "ansible-controller-security-group"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.ansible_ingress_ip_address]
  }

  egress {
    protocol    = "-1" 
    from_port   = 0    
    to_port     = 0   
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ansible-controller" {
  ami                         = "ami-08b5b3a93ed654d19" # normal Amazon Linux AMI
  key_name                    = var.ansible_ssh_key
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.ansible-sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install ansible -y

    # Ensure pip3 is installed correctly
    sudo yum install -y python3-pip 
    python3 -m ensurepip --default-pip 
    python3 -m pip install --upgrade --user pip  

    # Install boto3 and botocore using pip3
    sudo python3 -m pip install boto3 botocore
  EOF


  tags = {
    Name = "Ansible Controller"
  }
}


# EC2 security group
resource "aws_security_group" "private-ec2-sg" {
  name   = "private-ec2-security-group"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = [aws_security_group.ansible-sg.id] 
  }

  egress {
    protocol    = "-1" 
    from_port   = 0    
    to_port     = 0    
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Private Ubuntu EC2 instances
resource "aws_instance" "private_ubuntu_instances" {
  count                  = 3
  ami                    = "ami-084568db4383264d4"
  key_name               = var.private_ssh_key
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.private-ec2-sg.id]

  tags = {
    Name = "private-ubuntu-${count.index + 1}"
    OS   = "ubuntu"
  }
}

# Private Amazon Linux EC2 instances
resource "aws_instance" "private_amazon_linux_instances" {
  count                  = 3
  ami                    = "ami-08b5b3a93ed654d19"
  key_name               = var.private_ssh_key
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.private-ec2-sg.id]

  tags = {
    Name = "private-amazon_linux-${count.index + 1}"
    OS   = "amazon"
  }
}

