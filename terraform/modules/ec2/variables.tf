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

variable "enable_jenkins" {
  type    = bool
  default = true # start with Jenkins enabled by default, can be set to false if not needed.
}

variable "enable_bastion" {
  type    = bool
  default = true # Bastion host is optional, set to false by default.if you need it, set to true.
}

variable "enable_infra" {
  type    = bool
  default = true # start with Infra server enabled by default, can be set to false if not needed.
}

variable "enable_developer" {
  type    = bool
  default = true # start with Developer node enabled by default, can be set to false if not needed.
}

variable "developer_count" {
  type    = number
  default = 3 # Default to 3 developer nodes, can be adjusted as needed.if need more, set to the desired number.example: 3 for 3 developer nodes.
}
