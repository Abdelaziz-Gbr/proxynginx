variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
variable "route_table_name" {
  description = "The name of the Route Table"
  type        = string
}
variable "internet_gw_id" {
  description = "The ID of the Internet Gateway"
  type        = string
}