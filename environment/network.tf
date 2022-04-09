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
  subnets            = local.public_subnets
  #security_groups    = [aws_security_group.lb_sg.id] ## TODO: create custom ALB SG

  # Change to true once TF testing is complete
  enable_deletion_protection = false

  # TODO (time permitting)
  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  # tags = {
  #   Environment = "production"
  # }
}

resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-2019-08"
  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

resource "aws_lb_target_group" "wp_server" {
  name     = "wpserver1-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app_plane.id
}

resource "aws_lb_target_group_attachment" "wpserver1" {
  target_group_arn = aws_lb_target_group.wp_server.arn
  target_id        = aws_instance.wpserver1.id
  port             = 80
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

#######################
#### SUBNET GROUPS ####
#######################

resource "aws_db_subnet_group" "rds_private" {
  name       = "RDS Subnet Group"
  subnet_ids = [aws_subnet.db_2.id]
}