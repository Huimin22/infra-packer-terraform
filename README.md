# AWS Infrastructure with Packer and Terraform


## Intro  
This project automates AWS infrastructure provisioning using **Packer** and **Terraform**.  

1. **Packer** is used to create a custom Amazon Machine Image (AMI) that includes:  
   - Amazon Linux  
   - Docker installed  
   - SSH public key pre-configured for secure access  

2. **Terraform** provisions AWS resources:  
   - A **VPC** with private and public subnets  
   - A **bastion host** in the public subnet (only accessible from your IP on port 22)  
   - **Six EC2 instances** in the private subnet using the custom AMI  


## Preparation
Install [Packer](https://developer.hashicorp.com/packer/downloads) and [Terraform](https://developer.hashicorp.com/terraform/downloads).

## Usage

Clone this repo to your local machine

### AWS Configuration
```sh
aws configure
aws configure set aws_session_token your-token
```

### Generate SSH Key
Enter your directory and generate the key.
```sh
ssh-keygen -t rsa -b 4096 -f my-key
```

### Create Custom AMI with Packer
```sh
packer init .
packer fmt .
packer validate .
packer build amazon-linux-ami.pkr.hcl
```
![](build.png)  
![](ami.png)

### Deploy AWS Resources with Terraform
```sh
terraform init
terraform plan
terraform apply
```

## Result

### Access Bastion Host
Now you can access your Bastion Host.
```sh
ssh -A -i my-key ec2-user@your-public-ip
```
You connect to Private EC2 from your Bastion host.
### Connect to Private EC2 from Bastion
```sh
ssh ec2-user@private-ec2-ip
```

### Destroy Resources
If you want to delete all the resources, use this command. 
```sh
terraform destroy
```

