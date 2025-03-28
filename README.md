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

### Configure Variables

Before applying the Terraform configuration, update the following variables in your variable file to match your environment:

1. **`aws_region`**: Set the AWS region you want to use.
   - Example: `"us-east-1"`

2. **`public_key`**: Specify the name of your local public SSH key (without the file extension).
   - Example: `"my-key"`

3. **`my_ip`**: Replace this with your local IP address (in CIDR notation).
   - Example: `"70.000.66.125/32"` (Ensure it's your current IP address for secure SSH access)

### Create Custom AMI with Packer
```sh
packer init .
packer fmt .
packer validate .
packer build amazon-linux-ami.pkr.hcl
```
![](./pic/build.png)  
![](./pic/ami.png)

### Deploy AWS Resources with Terraform
```sh
terraform init
terraform plan
terraform apply
```

![](./pic/launchvm.png)  
![](./pic/bastion1.png)

![](./pic/inboundrule.png)

![](./pic/showvm.png)
![](./pic/private-vm-ami.png)
![](./pic/privatevm.png)

![](./pic/vpc2.png)
![](./pic/vpc1.png)
## Result

### Access Bastion Host
Now you can access your Bastion Host. 
Before accessing your Bastion Host, add your private key to the SSH agent。
```sh
ssh-add your-key
```
```sh
ssh -A -i my-key ec2-user@your-public-ip
```
You connect to Private EC2 from your Bastion host.
### Connect to Private EC2 from Bastion
```sh
ssh ec2-user@private-ec2-ip
```
![](./pic/sshvm.png)

### Destroy Resources
If you want to delete all the resources, use this command. 
```sh
terraform destroy
```

