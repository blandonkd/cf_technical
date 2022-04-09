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
  ami           = data.aws_ami.redhat.id
  instance_type = "t3.micro"
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
  ami           = data.aws_ami.redhat.id
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