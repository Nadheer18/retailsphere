output "kubeadm_master_public_ip" {
  value = var.enable_kubeadm_master ? aws_instance.kubeadm_master[0].public_ip : null
}

output "kubeadm_worker_public_ips" {
  value = [for w in var.enable_kubeadm_worker ? aws_instance.kubeadm_worker : [] : w.public_ip]
}

output "kubeadm_master_private_ip" {
  value = var.enable_kubeadm_master ? aws_instance.kubeadm_master[0].private_ip : null
}

output "kubeadm_worker_private_ips" {
  value = [for w in var.enable_kubeadm_worker ? aws_instance.kubeadm_worker : [] : w.private_ip]
}

output "kubeadm_master_ssh_command" {
  value = {
    master = var.enable_kubeadm_master ? "ssh -i $mumbai-region.pem ec2-user@${aws_instance.kubeadm_master[0].public_ip}" : null
    worker = var.enable_kubeadm_worker ? [for w in aws_instance.kubeadm_worker : "ssh -i $mumbai-region.pem ec2-user@${w.public_ip}"] : null
    }
}