# Security Group para las instancias EC2 (Web y Aplicación)
resource "aws_security_group" "app_sg" {
  name        = "pi-app-sg"
  description = "Security Group para plataforma EdTech"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Administracion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    description = "Salida a Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pi-app-sg"
  }
}

# Security Group exclusivo para el RDS (Base de datos)
resource "aws_security_group" "rds_sg" {
  name        = "pi-rds-sg"
  description = "Permitir trafico desde las instancias EC2 al RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL desde el Security Group de las VMs"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pi-rds-sg"
  }
}
