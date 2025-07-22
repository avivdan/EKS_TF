resource "aws_subnet" "eks_public_subnet" {
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.availability_zone_public_subnet
  map_public_ip_on_launch = true  

  tags = {
    Name = "eks-public-subnet"
    "kubernetes.io/role/elb" = "1" 
  }
}


resource "aws_subnet" "eks_private_subnet" {
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.availability_zone_private_subnet
  tags = {
    Name = "eks-private-subnet"
    "kubernetes.io/role/internal-elb" = "1" 
  }
}