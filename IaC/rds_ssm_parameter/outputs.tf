output "db_endpoint" {
  value = aws_db_instance.prod.endpoint
}
output "db_username" {
  value = aws_db_instance.prod.username
}
output "db_address" {
  value = aws_db_instance.prod.address
}
output "db_password" {
  value     = data.aws_ssm_parameter.rds_password
  sensitive = true
}
