#############
#### VPC ####
#############

resource "aws_vpc" "app_plane" {
  cidr_block = "10.1.0.0/16"
}

###################################
#### APPLICATION LOAD BALANCER ####
###################################

resource "aws_lb" "application_lb" {
  name               = "Application-LB"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
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
  load_balancer_arn = aws_lb.application_lb.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-FS-1-2-2019-08"
  #certificate_arn   = aws_acm_certificate.public_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wp_server.arn
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
## TODO: add IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_plane.id
}

resource "aws_nat_gateway" "ngw" {
  subnet_id     = aws_subnet.public_1.id
  allocation_id = aws_eip.nat_eip.id

  # Dependency added to rely on IGW
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

# Public subnet
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.app_plane.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# Public subnet
resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.app_plane.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}
#########################
#### PRIVATE SUBNETS ####
#########################

# Private subnet
resource "aws_subnet" "webapp_1" {
  vpc_id            = aws_vpc.app_plane.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "us-west-2a"
}
resource "aws_route_table_association" "webapp_1" {
  subnet_id      = aws_subnet.webapp_1.id
  route_table_id = aws_route_table.private.id
}

# Private subnet
resource "aws_subnet" "webapp_2" {
  vpc_id            = aws_vpc.app_plane.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "us-west-2b"
}
resource "aws_route_table_association" "webapp_2" {
  subnet_id      = aws_subnet.webapp_2.id
  route_table_id = aws_route_table.private.id
}

# Private subnet
resource "aws_subnet" "db_1" {
  vpc_id            = aws_vpc.app_plane.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = "us-west-2a"
}
resource "aws_route_table_association" "db_1" {
  subnet_id      = aws_subnet.db_1.id
  route_table_id = aws_route_table.private.id
}

# Private subnet
resource "aws_subnet" "db_2" {
  vpc_id            = aws_vpc.app_plane.id
  cidr_block        = "10.1.5.0/24"
  availability_zone = "us-west-2b"
}
resource "aws_route_table_association" "db_2" {
  subnet_id      = aws_subnet.db_2.id
  route_table_id = aws_route_table.private.id
}

#######################
#### SUBNET GROUPS ####
#######################
## TODO: add secondary subnet in different AZ per requirments
resource "aws_db_subnet_group" "rds_private" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.db_1.id, aws_subnet.db_2.id]
}