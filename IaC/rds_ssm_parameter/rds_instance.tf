//RDS MySQL DB instance creation

resource "aws_db_instance" "prod" {
  identifier             = "prod-mysql-rds"
  instance_class         = "db.t2.micro"
  allocated_storage      = 8
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  vpc_security_group_ids = [""]
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  apply_immediately      = true
  username               = "administrator"
  password               = data.aws_ssm_parameter.rds_password.value
}

//Generate Password
resource "random_password" "main" {
  length           = 20
  special          = true
  override_special = "#!$_"
}

// Store Password
resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/prod-mysql-rds/password"
  description = "Master password for RDS Database"
  type        = "SecureString"
  value       = random_password.main.result
}

// Retrive Password
data "aws_ssm_parameter" "rds_password" {
  name       = "/prod/prod-mysql-rds/password"
  depends_on = [aws_ssm_parameter.rds_password]
}
