output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "rds_port" {
  value = aws_db_instance.mysql.port
}

output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}