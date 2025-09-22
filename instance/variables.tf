variable "instance_type"{
  description = "Type of EC2 instance"
  type        = string
}
variable "subnet_id"{
  description = "The ID of the Subnet associated with the instance"
  type        = string
}
variable "key_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
}
variable "security_group_id" {
  description = "The ID of the security group to associate with the instance"
  type        = string
}
variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
}