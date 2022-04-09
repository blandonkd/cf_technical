#Windows 2019 instance
resource "aws_instance" "bastion1" {
  ami           = data.aws_ami.windows_2019.id
  instance_type = "t3a.medium"
  subnet_id     = aws_subnet.public_1.id
  root_block_device {
      encrypted = true
      volume_size = 50
  }
  tags = {
      name = "bastion1"
  }
}

#Redhat instance
resource "aws_instance" "wpserver1" {
  #ami           = data.aws_ami.redhat.id
  ami = "ami-0b28dfc7adc325ef4"
  instance_type = "t3a.micro"
  subnet_id     = aws_subnet.webapp_1.id
  root_block_device {
      encrypted = true
      volume_size = 20
  }
  tags = {
      name = "wpserver1"
  }
}

#Redhat instance
resource "aws_instance" "wpserver2" {
  #ami           = data.aws_ami.redhat.id
  ami = "ami-0b28dfc7adc325ef4"
  instance_type = "t3a.micro"
  subnet_id     = aws_subnet.webapp_2.id
  root_block_device {
      encrypted = true
      volume_size = 20
  }
  tags = {
      name = "wpserver2"
  }
}

# RDS Database instance
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_subnet_group_name = aws_db_subnet_group.rds_private.id
  engine               = "postgres"
  engine_version       = "11.15"
  instance_class       = "db.t3.micro"
  name              = "RDS1"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true  #set to false for PROD
}