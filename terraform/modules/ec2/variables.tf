variable "sg_name" {
  type = string
  default = "ecs_sg"
}

variable "subnet" {
  type = string
  description = "Subnet ID to launch instances"
}

variable "sg_id" {
  type = string
  description = "Security group ID"
}


variable "ec2_name" {
  type = string
  description = "Ec2 name"
}


###########
# variable "elb_ec2_name" {
#   type = string
#   description = "elb attach"
# }



variable "tg" {
  type = string
}