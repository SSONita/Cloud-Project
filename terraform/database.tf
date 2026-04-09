#Subnet
resource "aws_db_subnet_group" "postgres_subnet" {
  name = "postgres-subnet-group"

  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  tags = {
    Name = "Postgres Subnet Group"
  }
}

#RDS security group
resource "aws_security_group" "rds_sg" {
  name   = "rds-security-group"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id] # ✅ ONLY EC2 can access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Postgres RDS
resource "aws_db_instance" "postgres_db" {
  identifier        = "student2-postgres-db"
  engine            = "postgres"
  engine_version    = "14"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "myappdb"
  username = "postgresuser"
  password = "StrongPassword123!"

  publicly_accessible = false  # 🔥 better (since EC2 is inside VPC)
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet.name

  tags = {
    Name = "Postgres DB"
  }
}