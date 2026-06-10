output "jenkins_sg_id" {
  value = aws_security_group.jenkins.id
}

output "infra_sg_id" {
  value = aws_security_group.infra.id
}

output "developer_sg_id" {
  value = aws_security_group.developer.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}

output "kubeadm_cluster_sg_id" {
  value = aws_security_group.kubeadm_cluster.id
}

output "eks_cluster_sg_id" {
  value = aws_security_group.eks_cluster.id
}