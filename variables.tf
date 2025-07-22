variable "key_name" {
  description = "Name of the key pair to use for SSH access to the EC2 instance"
  type        = string
  default     = "ubuntu-aviv"
}

# AMI ID for Ubuntu 22.04 LTS
variable "ami_id" {
  description = "ID of the AMI to use for the EC2 instance"
  type        = string
  default     = "ami-0b8e4d801c75b0f0d"
}

# Instance type for t2.micro
variable "instance_type" {
  description = "Type of the EC2 instance to deploy"
  type        = string
  default     = "t3.micro"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "region" {
  description = "Region for the EC2 instance"
  type        = string
  default     = "eu-north-1"
}

variable "availability_zone_public_subnet" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "eu-north-1a"
}

variable "availability_zone_private_subnet" {
  description = "Availability zone for the private subnet"
  type        = string
  default     = "eu-north-1b"
}