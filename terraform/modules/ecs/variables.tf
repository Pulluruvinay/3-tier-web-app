variable "private_subnets" {}
variable "target_group_arn" {}
variable "ecr_image" {}
variable "db_host" {}
variable "db_user" {}
variable "db_password" {}
variable "vpc_id" {
  type = string
}

