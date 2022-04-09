terraform {
  backend "local" {
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      Project     = "Technical Challenge"
      Environment = "Dev"
    }
  }
}