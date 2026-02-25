output "frontend_public_ip" {
  value = aws_instance.frontend.public_ip
}

output "backend_private_ip" {
  value = aws_instance.backend.private_ip
}

output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}
