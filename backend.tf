terraform {
  backend "s3" {
    bucket         = "terraform-state-eks-cluster-1" 
    key            = "eks-cluster/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    use_lockfile   = true
  }
}