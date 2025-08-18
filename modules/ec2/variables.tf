variable "region" {
  description = "Default region (us-east-1)"
  type = string
}

variable "ami_id" {
  description = "Default AMI id"
  type = string
}

variable "instance_type" {
  description = "Default instance type"
  type = string
}

variable "vpc_id" {
  description = "VPC id"
  type = string
}

variable "subnet_public_id" {
  description = "Public subnet ID"
  type = string
}