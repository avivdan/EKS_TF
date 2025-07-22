output "ecr_url" {
  value = aws_ecr_repository.flask_demo.repository_url
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "iam_role_arn" {
  value = aws_iam_role.node_group.arn
}

output "iam_role_name" {
  value = aws_iam_role.node_group.name
}

output "iam_role_policy_arn" {
  value = aws_iam_role_policy_attachment.ecr_read.policy_arn
}

output "iam_role_policy_name" {
  value = aws_iam_role_policy_attachment.ecr_read.role
}

output "iam_role_policy_id" {
  value = aws_iam_role_policy_attachment.ecr_read.id
}

output "kubeconfig" {
  value = <<EOT
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${aws_eks_cluster.eks_cluster.certificate_authority[0].data}
    server: ${aws_eks_cluster.eks_cluster.endpoint}
  name: ${aws_eks_cluster.eks_cluster.name}
EOT
}