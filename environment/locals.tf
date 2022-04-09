# Create locals
locals {
  public_subnets = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}
