output "public_sg_id" {
    value       = aws_security_group.public_sg.id
    description = "The ID of the public security group"
}