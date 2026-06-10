output "jenkins_instance_profile" {
  value = aws_iam_instance_profile.jenkins.name
}

output "infra_instance_profile" {
  value = aws_iam_instance_profile.infra.name
}

output "developer_instance_profile" {
  value = aws_iam_instance_profile.developer.name
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node.arn
}