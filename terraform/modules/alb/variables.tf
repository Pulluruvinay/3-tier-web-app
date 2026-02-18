variable "vpc_id" {
    description = "VPC ID for ALB"
    type        = string
}
variable "public_subnets" {
    type = list(string)
}
