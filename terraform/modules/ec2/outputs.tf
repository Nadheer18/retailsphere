output "jenkins_public_ip" {
  value = var.enable_jenkins ? aws_instance.jenkins[0].public_ip : null 
}

output "infra_public_ip" {
  value = var.enable_infra ? aws_instance.infra[0].public_ip : null
}

output "developer_public_ips" {
  #value = var.enable_developer ? aws_instance.developer[*].public_ip : null
  value = [for w in var.enable_developer ? aws_instance.developer : [] : w.public_ip]
}

output "bastion_public_ip" {
  value = var.enable_bastion ? aws_instance.bastion[0].public_ip : null
}

output "jenkins_private_ip" {
  value = var.enable_jenkins ? aws_instance.jenkins[0].private_ip : null 
}

output "infra_private_ip" {
  value = var.enable_infra ? aws_instance.infra[0].private_ip : null
}

output "developer_private_ips" {
  #value = var.enable_developer ? aws_instance.developer[*].private_ip : null
  value = [for w in var.enable_developer ? aws_instance.developer : [] : w.private_ip]
}

output "bastion_private_ip" {
  value = var.enable_bastion ? aws_instance.bastion[0].private_ip : null
}

output "jenkins_url" {
  value = var.enable_jenkins ? "http://${aws_instance.jenkins[0].public_ip}:8080" : null
}

output "ssh_command" {
  value = {
    jenkins = var.enable_jenkins ? "ssh -i $mumbai-region.pem ec2-user@${aws_instance.jenkins[0].public_ip}" : null
    infra   = var.enable_infra ? "ssh -i $mumbai-region.pem ec2-user@${aws_instance.infra[0].public_ip}" : null
    bastion = var.enable_bastion ? "ssh -i $mumbai-region.pem ec2-user@${aws_instance.bastion[0].public_ip}" : null
    developer = var.enable_developer ? [for w in aws_instance.developer : "ssh -i $mumbai-region.pem ec2-user@${w.public_ip}"] : null  
  }
}