terraform {
  backend "s3" {
    bucket         = "vj-test-ecr-79"  
    key            = "terraform.tfstate"  
    region         = "us-east-2" 
    encrypt        = true
  }
}


module "ec2" {
  source                                 = "../modules/ec2"
  subnet                                 = module.network.subnet_id
  sg_id                                  = module.network.security_group_id

}


module "network" {
  source                                 = "../modules/network"
  sg_name = var.sg_name
}

