resource "aws_vpc" "app_plane" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name    = "Application Plane"
    Project = "Technical"
  }
}

# Public subnet
resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.0.0/24"
}

# Public subnet
resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.1.0/24"
}

# Private subnet
resource "aws_subnet" "webapp_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.2.0/24"
}

# Private subnet
resource "aws_subnet" "webapp_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.3.0/24"
}

# Private subnet
resource "aws_subnet" "db_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.4.0/24"
}

# Private subnet
resource "aws_subnet" "db_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.5.0/24"
}