variable "vpc_cidr" {
  description = "VPC CIDR block"
  type = string
}

variable "region" {
  description = "us-east-1"
  type = string
}

variable "availability_zone" {
  description = "az-a"
  type = string
}

variable "public_cidr" {
  type = string
}

variable "private_apps_cidr" {
  type = string
}

variable "private_db_cidr" {
  type = string
}