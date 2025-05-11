data "aws_iam_instance_profile" "ecs_profile" {
  name = "vj-ecs-ec2-1"
}



##################qa ###############

resource "aws_instance" "ecs_instance" {
  ami                         = "ami-0c3b809fcf2445b6a"
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet
  vpc_security_group_ids      = [var.sg_id]
  iam_instance_profile        = data.aws_iam_instance_profile.ecs_profile.name
  associate_public_ip_address = true
  key_name                    = "vj-test"

  tags = {
    Name = var.ec2_name
  }
}



####################Auto scaling purpose###############


# # Launch Template
# resource "aws_launch_template" "ecs_launch_template" {
#   name_prefix   = "ecs-lt-${var.ec2_name}"
#   image_id      = "ami-0c3b809fcf2445b6a"
#   instance_type = "t2.micro"
#   key_name      = "vj-test"

#   iam_instance_profile {
#     name = data.aws_iam_instance_profile.ecs_profile.name
#   }

#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups             = [var.sg_id]
#   }

#   user_data = base64encode(<<-EOF
#     #!/bin/bash
#     sudo apt update -y
#     sudo apt install -y git curl nginx amazon-ssm-agent

#     systemctl enable amazon-ssm-agent
#     systemctl start amazon-ssm-agent

#     curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
#     sudo apt install -y nodejs
#     sudo npm install -g pm2

#     cd /home/ubuntu
#     git clone -b main https://github.com/VidyaranyaRJ/application.git myapp || true
#     cd myapp/nodejs
#     npm install
#     pm2 start index.js --name node-app
#     pm2 startup systemd
#     pm2 save

#     sudo bash -c 'cat > /etc/nginx/sites-available/default' <<NGINX
#     server {
#       listen 80;
#       location / {
#         proxy_pass http://localhost:8000;
#         proxy_http_version 1.1;
#         proxy_set_header Upgrade \$http_upgrade;
#         proxy_set_header Connection "upgrade";
#         proxy_set_header Host \$host;
#         proxy_cache_bypass \$http_upgrade;
#       }
#     }
#     NGINX

#         sudo systemctl restart nginx
#       EOF
#   )

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name        = var.ec2_name
#       Role        = "NodeAutoScale"
#     }
#   }
# }

# # Auto Scaling Group
# resource "aws_autoscaling_group" "ecs_asg" {
#   name_prefix               = "ecs-asg-${var.ec2_name}"
#   max_size                  = 2
#   min_size                  = 1
#   desired_capacity          = 1
#   vpc_zone_identifier       = [var.subnet]
#   health_check_type         = "ELB"
#   health_check_grace_period = 300
#   force_delete              = true

#   launch_template {
#     id      = aws_launch_template.ecs_launch_template.id
#     version = "$Latest"
#   }

#   target_group_arns = [var.tg]

#   tag {
#     key                 = "Name"
#     value               = var.ec2_name
#     propagate_at_launch = true
#   }
# }


