output "database_endpoint" {
  value = aws_db_instance.database.endpoint
  description = "Postgres endpoint"
}

output "db_sg_id" {
  value = aws_security_group.db_security_group.id
  description = "Postgres security group ID"
}