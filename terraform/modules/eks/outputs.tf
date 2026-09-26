# =========================================================
# EKS CLUSTER OUTPUTS
# =========================================================

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


# =========================================================
# IAM OUTPUTS
# =========================================================

output "cluster_iam_role_arn" {

  description = "EKS cluster IAM role ARN"

  value = aws_iam_role.eks_cluster.arn
}


output "node_iam_role_arn" {

  description = "EKS node IAM role ARN"

  value = aws_iam_role.eks_node.arn
}


output "ebs_csi_role_arn" {

  description = "EBS CSI driver IAM role ARN"

  value = aws_iam_role.ebs_csi.arn
}


# =========================================================
# NODE GROUP OUTPUT
# =========================================================

output "node_group_name" {

  description = "EKS managed node group name"

  value = aws_eks_node_group.this.node_group_name
}


# =========================================================
# OIDC OUTPUT
# =========================================================

output "oidc_issuer" {

  description = "EKS OIDC issuer URL"

  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}


output "oidc_provider_arn" {

  description = "EKS OIDC provider ARN"

  value = aws_iam_openid_connect_provider.eks.arn
}


# =========================================================
# EBS CSI ADD-ON OUTPUT
# =========================================================

output "ebs_csi_addon_name" {

  description = "EBS CSI EKS managed add-on name"

  value = aws_eks_addon.ebs_csi.addon_name
}