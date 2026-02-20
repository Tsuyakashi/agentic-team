terraform {
  required_providers {
    aws = {
      version = ">= 6.33"
    }
  }

  backend "s3" {
    bucket = "ag-team-tfstate"
    key    = "backend/terraform.tfstate"
    region = "eu-central-1"
    # dynamodb_table = "terraform-lock" # optional for locks
    # encrypt        = true
  }

  required_version = ">= 1.14.3"
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source         = "./network"
  vpc_cidr_block = var.vpc_cidr_block
  all_cidr       = var.all_cidr
  av_zone1       = var.av_zone_1
  av_zone2       = var.av_zone_2
}

module "instances" {
  source                = "./instances"
  subnet_id_public      = module.vpc.subnet-public
  subnet_id_private     = module.vpc.subnet-private
  security_group_public = module.vpc.instance_security_group_id
  key_pair              = var.instances_key_name
  instance_type         = var.instance_type
}

module "rds" {
  source               = "./rds"
  security_group       = module.vpc.rds-sec-group-id
  subnet_group_public  = module.vpc.rd-subnet-public
  subnet_group_private = module.vpc.rd-subnet-private
  av_zone1             = var.av_zone_1
  username             = var.db_username
  password             = var.db_password
}
