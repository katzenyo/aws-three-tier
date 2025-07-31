variable "region" {
    default = "us-east-1"
    type = string
}

### EC2 vars

variable "ami_id" {
    description = "Amazon Linux 2023 AMI 2023.8.20250721.2 x86_64 HVM kernel-6.1"
    default = "ami-08a6efd148b1f7504"
}

### DB vars

variable "db_pwd" {
    description = "Database password"
    type = string
    sensitive = true
}

### Networking vars

variable "vpc_cidr" {
  description = "Default VPC CIDR block"
  type = string
  default = "10.20.0.0/16"
}

variable "instance_type" {
  description = "Free tier instance type"
  type = string
  default = "t3.micro"
}