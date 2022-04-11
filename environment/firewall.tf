#########################
#### SECURITY GROUPS ####
#########################

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Custome security group for ALB"
  vpc_id      = aws_vpc.app_plane.id

  ingress {
    description = "HTTPS from all"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from all"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "win_sg" {
  name        = "win_sg"
  description = "Custome security group for Windows Instances"
  vpc_id      = aws_vpc.app_plane.id

  ingress {
    description = "RDP from all"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rh_sg" {
  name        = "rh_sg"
  description = "Custome security group for RedHat instances"
  vpc_id      = aws_vpc.app_plane.id

  ingress {
    description = "SSH from local"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Custome security group for RDS instances"
  vpc_id      = aws_vpc.app_plane.id

  ingress {
    description = "Open port for Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


##############
#### NACL ####
##############