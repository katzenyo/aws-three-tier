terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=6.7.0"
    }
  }

  # backend "s3" {
  #   bucket = "development-plan-tf-state-082025"
  #   key = "development-plan-aws-three-tier/terraform.tfstate"
  #   region = "us-east-1"
  #   use_lockfile = true
  # }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  region = var.region
  private_apps_cidr = var.private_apps_cidr
  private_db_cidr = var.private_db_cidr
  public_cidr = var.public_cidr
  public_subnet_cidr_az2 = var.public_subnet_cidr_az2
  private_db_cidr_az2 = var.private_db_cidr_az2
}

module "ec2" {
  source = "./modules/ec2"
  region = var.region
  instance_type = var.instance_type
  vpc_id = module.vpc.vpc_id
  ami_id = var.ami_id
  subnet_public_id = module.vpc.subnet_public_id
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  db_password = var.db_password
  subnet_private_id_az1 = module.vpc.subnet_db_private_id_az1
  subnet_private_id_az2 = module.vpc.subnet_db_private_id_az2
  security_group_app_id = aws_security_group.sg_app.id
}

# module "alb" {
#   source = "./modules/alb"
#   vpc_id = module.vpc.vpc_id
# }

module "asg" {
  source = "./modules/asg"
  subnet_private_app_id = module.vpc.subnet_private_app_id
  elb_app_target_group_arn = aws_lb_target_group.app_target_group.arn
  aws_ssm_ami_value = module.ec2.aws_ssm_ami_value
  iam_instance_profile_name = module.ec2.iam_instance_profile_name
  sg_app_id = aws_security_group.sg_app.id
}