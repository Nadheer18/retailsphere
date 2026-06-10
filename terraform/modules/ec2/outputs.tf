output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "infra_public_ip" {
  value = aws_instance.infra.public_ip
}

output "developer_public_ip" {
  value = aws_instance.developer.public_ip
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}