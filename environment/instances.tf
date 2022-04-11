#Windows 2019 instance
resource "aws_instance" "bastion1" {
  ami                         = data.aws_ami.windows_2019.id
  instance_type               = "t3a.medium"
  subnet_id                   = aws_subnet.public_1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.win_sg.id]
  key_name                    = "techChallenge"
  root_block_device {
    encrypted   = true
    volume_size = 50
  }
  tags = {
    Name = "bastion1"
  }
}

#Redhat instance
resource "aws_instance" "wpserver1" {
  #ami           = data.aws_ami.redhat.id
  ami                    = "ami-0b28dfc7adc325ef4"
  instance_type          = "t3a.micro"
  subnet_id              = aws_subnet.webapp_1.id
  vpc_security_group_ids = [aws_security_group.rh_sg.id]
  key_name               = "techChallenge"
  root_block_device {
    encrypted   = true
    volume_size = 20
  }
  user_data = <<EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd.x86_64
  systemctl start httpd.service
  systemctl enable httpd.service
  echo "Hello World from $(hostname -f)" > /var/www/html/index.html
  EOF
  tags = {
    Name = "wpserver1"
  }
}

#Redhat instance
resource "aws_instance" "wpserver2" {
  #ami                    = data.aws_ami.redhat.id   #TODO: fix data call (time permitting)
  ami                    = "ami-0b28dfc7adc325ef4"
  instance_type          = "t3a.micro"
  subnet_id              = aws_subnet.webapp_2.id
  vpc_security_group_ids = [aws_security_group.rh_sg.id]
  key_name               = "techChallenge"
  root_block_device {
    encrypted   = true
    volume_size = 20
  }
  user_data = <<EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd.x86_64
  systemctl start httpd.service
  systemctl enable httpd.service
  echo "Hello World from $(hostname -f)" > /var/www/html/index.html
  EOF
  tags = {
    Name = "wpserver2"
  }
}

# RDS Database instance
resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.rds_private.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  engine                 = "postgres"
  engine_version         = "11.15"
  instance_class         = "db.t3.micro"
  name                   = "RDS1"
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true # TODO: set to false for PROD
}