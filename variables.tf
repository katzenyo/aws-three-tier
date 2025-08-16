variable "region" {
  description = "default AWS region"
  default = "us-east-1"
  type = string
}

### EC2 vars

variable "ami_id" {
  description = "Amazon Linux 2023 AMI 2023.8.20250721.2 x86_64 HVM kernel-6.1 (${var.region})"
  default = "ami-08a6efd148b1f7504"
}

variable "instance_type" {
  description = "Free tier instance type"
  type = string
  default = "t3.micro"
}

### DB vars

variable "db_pwd" {
  description = "Database password"
  type = string
  sensitive = true
}

### Networking vars

variable "vpc_cidr" {
  description = "Primary VPC CIDR block"
  type = string
  default = "10.0.0.0/16"
}

### DB vars

variable "db_password" {
  description = "Database password"
  type = string
  sensitive = true
}