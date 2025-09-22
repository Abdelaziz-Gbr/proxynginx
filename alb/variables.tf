variable "name" {
  description = "The name of the load balancer"
  type        = string
}
variable "internal" {
  description = "Boolean to indicate if the load balancer is internal"
  type        = bool
}
variable "security_group_id" {
  description = "The security group ID to associate with the load balancer"
  type        = string
}
variable "subnet_ids" {
  description = "The subnet IDs to associate with the load balancer"
  type        = list(string)
}
variable "target_group_name" {
  description = "The name of the target group"
  type        = string
}
variable "vpc_id" {
  description = "The VPC ID where the target group will be created"
  type        = string
}
variable "instance_type" {
  description = "The instance type for the launch template"
  type        = string
}
variable "key_name" {
  description = "The key pair name to use for the instances"
  type        = string
}
variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instances"
  type        = bool
}

variable "asg_name" {
  description = "The name of the Auto Scaling group"
  type        = string
}

variable "max_size" {
  description = "The maximum size of the Auto Scaling group"
  type        = number
}
variable "min_size" {
  description = "The minimum size of the Auto Scaling group"
  type        = number
}
variable "desired_capacity" {
  description = "The desired capacity of the Auto Scaling group"
  type        = number
}
variable "user_data" {
  description = "The user data script to configure instances"
  type        = string
}
