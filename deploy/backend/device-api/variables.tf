variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "instance_type" {
  type    = string
}

variable "desired_size" {
  type = number
}

variable "aws_auth_map_roles" {
  type    = string
  default = ""
}
