variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}