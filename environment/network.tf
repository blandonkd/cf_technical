#############
#### VPC ####
#############

resource "aws_vpc" "app_plane" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name    = "Application Plane"
    Project = "Technical"
  }
}

###################################
#### APPLICATION LOAD BALANCER ####
###################################

resource "aws_lb" "application_lb" {
  name               = "Application-LB"
  internal           = false
  load_balancer_type = "application"
  #security_groups    = [aws_security_group.lb_sg.id] ## TODO: create ALB SG
  subnets            = local.public_subnets

  enable_deletion_protection = true

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  # tags = {
  #   Environment = "production"
  # }
}

########################
#### PUBLIC SUBNETS ####
########################

## TODO: do data calls for AZ ids???

# Public subnet
resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.app_plane.id
  cidr_block = "10.1.0.0/24"
  availability_zone = "us-west-2a"
}

# Public subnet
resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.app_plane.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-west-2b"
}

#########################
#### PRIVATE SUBNETS ####
#########################

# Private subnet
resource "aws_subnet" "webapp_1" {
  vpc_id     = aws_vpc.app_plane.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "us-west-2a"
}

# Private subnet
resource "aws_subnet" "webapp_2" {
  vpc_id     = aws_vpc.app_plane.id
  cidr_block = "10.1.3.0/24"
  availability_zone = "us-west-2b"
}

# Private subnet
resource "aws_subnet" "db_1" {
  vpc_id     = aws_vpc.app_plane.id
  cidr_block = "10.1.4.0/24"
  availability_zone = "us-west-2a"
}

# Private subnet
resource "aws_subnet" "db_2" {
  vpc_id     = aws_vpc.app_plane.id
  cidr_block = "10.1.5.0/24"
  availability_zone = "us-west-2b"
}