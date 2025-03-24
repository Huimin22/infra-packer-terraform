variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "public_key" {
  description = "Your local public key"
  type        = string
  default     = "my-key"
}

variable "my_ip" {
  description = "Your local IP address"
  type        = string
  default     = "73.231.66.185/32"	# replace with your IP
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
