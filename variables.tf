variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "The ami id"
  type        = string
  default     = "ami-033ad6a28a0007e09"
}

variable "bastion_prefix" {
  description = "Bastion Host"
  type        = string
  default     = "bastion_host"
}

variable "ansible_ssh_key" {
  type        = string
  default     = "devop" 
  description = "Your Ansible SSH Key"
}

variable "private_ssh_key" {
  type        = string
  default     = "devop" 
  description = "Your Private EC2 SSH Key"
}

variable "ansible_ingress_ip_address" {
  type        = string
  default     = "73.231.66.185/32" 
  description = "Your IP Address" # replace with your IP
}

variable "public_subnet_id" {
  type        = string
  default     = "10.0.101.0/24"
  description = "The VPC's public subnet IP"
}






