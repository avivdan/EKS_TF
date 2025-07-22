# Security Groups
resource "aws_security_group" "eks_cluster" {
  name        = "eks-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.eks_vpc.id


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "eks-cluster-sg"
  }
}


resource "aws_security_group" "eks_nodes" {
  name        = "eks-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.eks_vpc.id

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow node-to-node communication
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  tags = {
    Name = "eks-node-sg"
    "kubernetes.io/cluster/eks-cluster" = "owned"
  }
}

resource "aws_security_group_rule" "nodes_to_cluster" {
    type                     = "ingress"
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    security_group_id        = aws_security_group.eks_cluster.id
    source_security_group_id = aws_security_group.eks_nodes.id
    description              = "Allow nodes to communicate with cluster API"
}

resource "aws_security_group_rule" "cluster_to_nodes" {
    type                     = "ingress"
    from_port                = 0
    to_port                  = 0
    protocol                 = "-1"
    security_group_id        = aws_security_group.eks_nodes.id
    source_security_group_id = aws_security_group.eks_cluster.id
    description              = "Allow inbound from cluster SG"
}