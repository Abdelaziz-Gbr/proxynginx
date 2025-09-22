variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = list(string)
}

variable "internet_gw_name" {
  description = "The name of the Internet Gateway"
  type        = string
}

variable "route_table_name" {
  description = "The name of the Route Table"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
}

variable "private_instance" {
  description = "indicate if instance is private or public"
  type        = list(string)
}