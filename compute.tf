resource "aws_key_pair" "ssh_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

# 1. Creamos el Rol para las VMs
resource "aws_iam_role" "role_vm" {
  name = "diegoaws-role-ec2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
      }
    ]
  })
}

# 2. política de CloudWatch (Monitoreo)
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.role_vm.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# 3. política de S3 (Respaldos)
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.role_vm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# 4. política de SSM (Acceso web seguro / Gestión)
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.role_vm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# 5. El puente que metes en el compute.tf
resource "aws_iam_instance_profile" "profile_vm" {
  name = "diegoaws-instance-profile"
  role = aws_iam_role.role_vm.name
}

resource "aws_instance" "vm_app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_a.id
  key_name               = aws_key_pair.ssh_key.key_name
  user_data              = file("user_data.sh")
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.profile_vm.name

  tags = {
    Name = "pi-vm-app"
  }
}

resource "aws_instance" "vm_backup" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_b.id
  key_name               = aws_key_pair.ssh_key.key_name
  user_data              = file("user_data.sh")
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.profile_vm.name

  tags = {
    Name = "pi-vm-backup"
  }
}
