output "public_ips" {
  value = {
    jenkins = module.ec2.jenkins_public_ip
    infra   = module.ec2.infra_public_ip
    developer = {
      developer-01 = module.ec2.developer_public_ips[0]
    }
    bastion = module.ec2.bastion_public_ip
    kubeadm_master = module.kubeadm.kubeadm_master_public_ip
    kubeadm_workers = {
      worker-01 = module.kubeadm.kubeadm_worker_public_ips[0]
    }
  }
}

output "private_ips" {
  value = {
    jenkins = module.ec2.jenkins_private_ip
    infra   = module.ec2.infra_private_ip
    developer = { 
      developer-01 = module.ec2.developer_private_ips[0]
    }
    bastion = module.ec2.bastion_private_ip
    kubeadm_master = module.kubeadm.kubeadm_master_private_ip
    kubeadm_workers = {
      worker-01 = module.kubeadm.kubeadm_worker_private_ips[0]
    }
  }
}

output "jenkins_url" {
  value = module.ec2.jenkins_url
}

output "ssh_commands" {
  value = {
    jenkins = module.ec2.ssh_command.jenkins
    infra   = module.ec2.ssh_command.infra
    bastion = module.ec2.ssh_command.bastion
    developer = { 
      developer-01 = module.ec2.ssh_command.developer[0]
    }
    kubeadm_master = module.kubeadm.kubeadm_master_ssh_command.master
    kubeadm_workers = {
      worker-01 = module.kubeadm.kubeadm_master_ssh_command.worker[0]
    }
  }
}

output "kubeadm_cluster_info" {
  value = {
    master_public_ip = module.kubeadm.kubeadm_master_public_ip
    master_private_ip = module.kubeadm.kubeadm_master_private_ip
    worker_public_ips = {
      worker-01 = module.kubeadm.kubeadm_worker_public_ips[0]
    }
    worker_private_ips = {
      worker-01 = module.kubeadm.kubeadm_worker_private_ips[0]
    }
  }
}

output "developer_info" {
  value = {
    developer_public_ips = {
      developer-01 = module.ec2.developer_public_ips[0]
    }
    developer_private_ips = {
      developer-01 = module.ec2.developer_private_ips[0]
    }
  }
}