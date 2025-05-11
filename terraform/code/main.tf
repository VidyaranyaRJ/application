provider "aws" {
  region     = var.region

}


terraform {
  backend "s3" {
    # bucket         = "vj-test-ecr-79"  
    # key            = "terraform.tfstate"  
    # region         = "us-east-2" 
    # encrypt        = true 
  }
}

locals {
  sg_name = "sg_name_${var.environment}"
  ec2_name = "ec2-vj_${var.environment}"
}

module "ec2" {
  source                                 = "../modules/ec2"
  subnet                                 = module.network.subnet_id
  sg_id                                  = module.network.security_group_id
  ec2_name = local.ec2_name
  tg = module.alb.tg_arn
}


module "network" {
  source                                 = "../modules/network"
  sg_name = local.sg_name
}


module "alb" {
  source                                 = "../modules/elb"
  alb_name = var.alb_name
  sg_id = module.network.security_group_id
  subnet_ids= [module.network.subnet_id]
  vpc_id = module.network.vpc_id

}

