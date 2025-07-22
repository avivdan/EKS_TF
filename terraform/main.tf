terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
} 

provider "aws" {
  region = var.region
}


resource "aws_eks_cluster" "eks_cluster" {
  name = "eks-cluster"

  role_arn = aws_iam_role.cluster.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = [
      aws_subnet.eks_public_subnet.id,
      aws_subnet.eks_private_subnet.id,
    ]
    endpoint_public_access  = true   # Required for kubectl access
    endpoint_private_access = false  # Disable if not needed
    security_group_ids = [aws_security_group.eks_cluster.id]
  }
    

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

# public node group
resource "aws_eks_node_group" "public" {
  cluster_name    = "eks-cluster"
  node_group_name = "public-node-group"
  subnet_ids      = [aws_subnet.eks_public_subnet.id]
  node_role_arn   = aws_iam_role.node_group.arn

  scaling_config {
    desired_size = 1  
    max_size     = 2
    min_size     = 1
  }
  
  instance_types = [var.instance_type]  
  capacity_type  = "SPOT"        
  ami_type       = "AL2_x86_64"

  remote_access {
    ec2_ssh_key               = var.key_name  
    source_security_group_ids = [aws_security_group.eks_nodes.id]
  }

  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
    aws_security_group.eks_nodes,
    aws_security_group.eks_cluster,
    aws_security_group_rule.nodes_to_cluster,
    aws_security_group_rule.cluster_to_nodes,
    aws_security_group_rule.cluster_to_nodes,
  ]
  
  tags = { 
    Name = "public-node-group" 
  }
}

# private node group
resource "aws_eks_node_group" "private" {
  cluster_name    = "eks-cluster"
  node_group_name = "private-node-group"
  subnet_ids      = [aws_subnet.eks_private_subnet.id]
  node_role_arn   = aws_iam_role.node_group.arn
  
  scaling_config {
    desired_size = 1  
    max_size     = 2
    min_size     = 1
  }
  
  instance_types = [var.instance_type]  
  capacity_type  = "SPOT"        
  ami_type       = "AL2_x86_64"

  remote_access {
    ec2_ssh_key               = var.key_name  
    source_security_group_ids = [aws_security_group.eks_nodes.id]
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
  
  tags = { 
    Name = "private-node-group" 
  }
}

resource "aws_ecr_repository" "flask_demo" {
  name                 = "flask-demo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  lifecycle {
    ignore_changes = [name]
  }
}