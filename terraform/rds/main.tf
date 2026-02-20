resource "aws_db_subnet_group" "rds-sg" {
  name       = "db-subnet"
  subnet_ids = [var.subnet-group-public, var.subnet-group-private]
}

resource "aws_db_instance" "pg-db" {
  allocated_storage = 20
  db_name           = "agentic-db"
  storage_type      = "gp2"
  engine_version    = "17.6"
  instance_class    = "db.t3.micro"

  username               = var.username
  password               = var.password
  availability_zone      = var.av_zone1
  port                   = 5432
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.rds-sg.id
  vpc_security_group_ids = [var.security_group]
  skip_final_snapshot    = true

  tags = {
    Name = "postgres-rds"
  }
}
