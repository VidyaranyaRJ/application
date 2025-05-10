data "aws_iam_instance_profile" "ecs_profile" {
  name = "vj-ecs-ec2-1"
}



##################qa ###############

# resource "aws_instance" "ecs_instance" {
#   ami                         = "ami-0c3b809fcf2445b6a"
#   instance_type               = "t2.micro"
#   subnet_id                   = var.subnet
#   vpc_security_group_ids      = [var.sg_id]
#   iam_instance_profile        = data.aws_iam_instance_profile.ecs_profile.name
#   associate_public_ip_address = true
#   key_name                    = "vj-test"

#   tags = {
#     Name = var.ec2_name
#   }
# }



####################Auto scaling purpose###############

resource "aws_launch_template" "ecs_launch_template" {
  name_prefix   = "ecs-lt-${var.ec2_name}"
  image_id      = "ami-0c3b809fcf2445b6a"
  instance_type = "t2.micro"
  key_name      = "vj-test"

  iam_instance_profile {
    name = data.aws_iam_instance_profile.ecs_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.sg_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.ec2_name
    }
  }
}




resource "aws_autoscaling_group" "ecs_asg" {
  name_prefix          = "ecs-asg-${var.ec2_name}"
  max_size             = 2
  min_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = [var.subnet]
  health_check_type    = "EC2"
  force_delete         = true

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  load_balancers = [var.elb_ec2_name]

  tag {
    key                 = "Name"
    value               = var.ec2_name
    propagate_at_launch = true
  }
}
