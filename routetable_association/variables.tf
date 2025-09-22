variable "subnet_id" {
  description = "The ID of the subnet to associate with the route table"
  type        = string
}
variable "route_table_id" {
  description = "The ID of the route table to associate with the subnet"
  type        = string
}