variable "vpc_cidr" {
  description = "VPC CIDR block"
  type = string
}

variable "region" {
  description = "us-east-1"
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

variable "public_subnet_cidr_az2" {
  type = string
}

variable "private_db_cidr_az2" {
  type = string
}