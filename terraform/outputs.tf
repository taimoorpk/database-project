output "db_connection" {
  description = "Database connection details (sensitive)"
  value = {
    endpoint = aws_db_instance.postgres_db.endpoint
    port     = aws_db_instance.postgres_db.port
    database = aws_db_instance.postgres_db.db_name
    username = aws_db_instance.postgres_db.username
  }
  sensitive = true
}

output "security_group_id" {
  description = "Database security group ID"
  value       = aws_security_group.db_sg.id
}