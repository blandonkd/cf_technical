variable vpc_id {
  type        = string
  description = "Id for VPC to associate subnet with"
}

variable cidr_block {
  type        = string
  description = "CIDR for subnet"
}

variable availability_zone {
  type        = string
  default     = "us-west-2a"
  description = "Availability zone that the subnet resides in"
}
