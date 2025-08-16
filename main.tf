terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=6.7.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  region = var.region
}

module "ec2" {
  source = "./modules/ec2"
  region = var.region
  instance_type = var.instance_type
  vpc_id = module.vpc.vpc_id
  ami_id = var.ami_id
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  db_password = var.db_password
  subnet_private_id = module.vpc.subnet_private_id
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
}