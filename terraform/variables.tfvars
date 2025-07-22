# Name of the key pair to use for SSH access to the EC2 instance
key_name = "ubuntu-aviv"

# ID of the AMI to use for the EC2 instance (Ubuntu 22.04 LTS example)
ami_id = "ami-0b8e4d801c75b0f0d"

# Type of the EC2 instance to deploy
type        = "t3.micro"

# CIDR block for the VPC
vpc_cidr = "10.0.0.0/16"

# CIDR block for the public subnet
public_subnet_cidr = "10.0.1.0/24"

# CIDR block for the private subnet
private_subnet_cidr = "10.0.2.0/24"

# Region for the EC2 instance
region = "eu-north-1"

# Availability zone for the public subnet
availability_zone_public_subnet = "eu-north-1a"

# Availability zone for the private subnet
availability_zone_private_subnet = "eu-north-1b" 