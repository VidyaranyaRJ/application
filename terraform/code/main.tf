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
  elb_ec2_name = module.elb.aws_elb_elb_test_name


}


module "network" {
  source                                 = "../modules/network"
  sg_name = local.sg_name
}


module "elb" {
  source                                 = "../modules/elb"
  elb_name = var.elb_name
  # instance_id = moduke.ec2.ec2_id
}

