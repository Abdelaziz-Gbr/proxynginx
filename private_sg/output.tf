output "private_sg_id" {
  value       = aws_security_group.private_sg.id
  description = "The ID of the private security group"
}