provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  region = var.region
}

module "EC2" {
  source = "./modules/ec2"
  region = var.region
  instance_type = var.instance_type
  vpc_id = module.vpc_id
  ami_id = var.ami_id
}