variable "public_subnet_id" {
  type = string
}

variable "kubeadm_cluster_sg_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "enable_kubeadm_master" {
  type    = bool
  default = true # Kubernetes master node is false by default. If you need it, set to true.
}

variable "enable_kubeadm_worker" {
  type    = bool
  default = true # Kubernetes worker nodes are false by default. If you need them, set to true.
} 

variable "worker_count" {
  type    = number
  default = 1 # Default to 2 worker nodes, can be adjusted as needed. If need more, set to the desired number. example: 3 for 3 worker nodes.
}