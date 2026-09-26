output "cluster_name" {

  description = "EKS cluster name"

  value = aws_eks_cluster.this.name
}


output "cluster_arn" {

  description = "EKS cluster ARN"

  value = aws_eks_cluster.this.arn
}


output "cluster_endpoint" {

  description = "EKS cluster API endpoint"

  value = aws_eks_cluster.this.endpoint
}


output "cluster_version" {

  description = "EKS Kubernetes version"

  value = aws_eks_cluster.this.version
}


output "cluster_security_group_id" {

  description = "EKS cluster security group ID"

  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}


output "cluster_iam_role_arn" {

  description = "EKS cluster IAM role ARN"

  value = aws_iam_role.eks_cluster.arn
}


output "node_iam_role_arn" {

  description = "EKS node IAM role ARN"

  value = aws_iam_role.eks_node.arn
}


output "node_group_name" {

  description = "EKS managed node group name"

  value = aws_eks_node_group.this.node_group_name
}