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

resource "aws_launch_configuration" "ecs_launch_config" {
  name_prefix          = "ecs-launch-$(var.ec2_name)"
  image_id             = "ami-0c3b809fcf2445b6a"
  instance_type        = "t2.micro"
  security_groups      = [var.sg_id]
  associate_public_ip_address = true
  key_name             = "vj-test"
  iam_instance_profile = data.aws_iam_instance_profile.ecs_profile.name

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_autoscaling_group" "ecs_asg" {
  name_prefix          = "ecs-asg-$(var.ec2_name)"
  max_size             = 2
  min_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = [var.subnet]
  health_check_type    = "EC2"
  force_delete         = true
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  load_balancers       = [var.elb_ec2_name]

  tag {
    key                 = "Name"
    value               = var.ec2_name
    propagate_at_launch = true
  }
}
