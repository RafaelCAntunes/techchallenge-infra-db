variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "eks_node_group_sg_id" {
  type = string
}