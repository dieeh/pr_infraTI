# Grupo de subredes para el RDS (Exige que la BD use al menos dos zonas de disponibilidad)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "pi-rds-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  tags = {
    Name = "pi-rds-subnet-group"
  }
}

# Instancia de la Base de Datos RDS
resource "aws_db_instance" "postgres_db" {
  identifier             = "edtech-db-instance"
  allocated_storage      = 20
  max_allocated_storage  = 50
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t3.micro"
  db_name                = "edtech"
  username               = "db_admin"
  password               = "REPLACE_WITH_DB_PASSWORD"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
}
