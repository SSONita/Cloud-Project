//deploy database in private network
resource "aws_db_subnet_group" "db_subnet" {
  name = "auth-db-subnet"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

resource "aws_db_instance" "auth_db" {
  allocated_storage      = 20
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = "db.t3.micro"

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  port                   = var.db_port

  publicly_accessible    = false
  skip_final_snapshot    = true

  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}