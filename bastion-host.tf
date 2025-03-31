provider "aws" {
  region = "us-east-1" # Specify the region
  profile = "default"
}

//bastion host vm
data "aws_ami" "image" {
  most_recent = true
  owners = ["self"] 

  filter {
    name = "tag:Application"
    values = ["my-ami"] 
  }
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.image.id 
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnets[0] 
  vpc_security_group_ids = [aws_security_group.bastion_sg.id] 

  associate_public_ip_address = true

  tags = {
    Name = "Bastion Host"
  }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
}

//private vm
resource "aws_instance" "private_ec2" {
  count                  = 6
  ami                    = data.aws_ami.image.id 
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[0] 
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]

  tags = {
    Name = "My-Private-Instance-${count.index + 1}"
  }
}
