variable "region" {
  description = "default AWS region"
  default = "us-east-1"
  type = string
}

### EC2 vars

variable "ami_id" {
  description = "Amazon Linux 2023 AMI 2023.8.20250721.2 x86_64 HVM kernel-6.1"
  default = "ami-08a6efd148b1f7504"
}

variable "instance_type" {
  description = "Free tier instance type"
  type = string
  default = "t3.micro"
}

### Networking vars

variable "vpc_cidr" {
  description = "Primary VPC CIDR block"
  type = string
  default = "10.0.0.0/16"
}

variable "public_cidr" {
  description = "Public subnet"
  type = string
  default = "10.0.1.0/24"
}

variable "private_apps_cidr" {
  description = "Private subnet for apps"
  type = string
  default = "10.0.2.0/24"
}

variable "private_db_cidr" {
  description = "Private subnet for the database"
  type = string
  default = "10.0.3.0/24"
}

variable "private_db_cidr_az2" {
  description = "Second private subnet for RDS, second AZ"
  type = string
  default = "10.0.4.0/24"
}

variable "public_subnet_cidr_az2" {
  description = "Second public subnet for ALB, multi-AZ"
  type = string
  default = "10.0.10.0/24"
}

### DB vars

variable "db_password" {
  description = "Database password"
  type = string
  sensitive = true
}