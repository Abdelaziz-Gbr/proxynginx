output "route_table_id"{
    description = "The ID of the Route Table"
    value       = aws_route_table.private_rt.id
}