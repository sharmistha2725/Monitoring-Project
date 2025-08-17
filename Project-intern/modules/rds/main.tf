resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  
  

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.medium"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.rds_sg_id]
  monitoring_role_arn = var.monitoring_role_arn
  monitoring_interval = 60
  username             = var.db_username
  password             = var.db_password
  db_name              = var.db_name
  skip_final_snapshot  = true
  multi_az             = true
  publicly_accessible  = false

  tags = {
    Name = "rds-mysql"
  }
}
