variable "public_subnet_id" {
  type = string
}

variable "jenkins_sg_id" {
  type = string
}

variable "infra_sg_id" {
  type = string
}

variable "developer_sg_id" {
  type = string
}

variable "bastion_sg_id" {
  type = string
}

variable "jenkins_instance_profile" {
  type = string
}

variable "infra_instance_profile" {
  type = string
}

variable "developer_instance_profile" {
  type = string
}

variable "key_name" {
  type = string
}