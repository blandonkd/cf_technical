data "aws_ami" "windows_2019" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}

data "aws_ami" "redhat" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["RHEL*"]
  }
}