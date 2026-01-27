output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "rds_port" {
  value = aws_db_instance.mysql.port
}

output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}

output "db_username" {
  value = var.db_username
}

output "db_password" {
  value = var.db_password
  sensitive = true
}


output "dynamodb_pagamentos_table_name" {
  description = "Nome da tabela DynamoDB de pagamentos"
  value       = aws_dynamodb_table.pagamentos.name
}

output "dynamodb_pagamentos_table_arn" {
  description = "ARN da tabela DynamoDB de pagamentos"
  value       = aws_dynamodb_table.pagamentos.arn
}

output "dynamodb_producao_table_name" {
  description = "Nome da tabela DynamoDB de produção"
  value       = aws_dynamodb_table.producao.name
}

output "dynamodb_producao_table_arn" {
  description = "ARN da tabela DynamoDB de produção"
  value       = aws_dynamodb_table.producao.arn
}

output "dynamodb_region" {
  description = "Região AWS do DynamoDB"
  value       = var.aws_region
}