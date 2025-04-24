data "aws_iam_instance_profile" "ecs_profile" {
  name = "vj-ecs-ec2-1"
}

resource "tls_private_key" "vj_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "vj_ec2_key" {
  key_name   = "vj-test"
  public_key = tls_private_key.vj_key.public_key_openssh
}

resource "local_file" "vj_key_pem" {
  content              = tls_private_key.vj_key.private_key_pem
  filename             = "C:/Users/vrjav/Downloads/Desktop folders/apl_deployment/terraform/vj-test.pem"
  file_permission      = "0400"
  directory_permission = "0700"
}


resource "aws_instance" "ecs_instance" {
  ami                         = "ami-0c3b809fcf2445b6a"
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet
  vpc_security_group_ids      = [var.sg_id]
  iam_instance_profile        = data.aws_iam_instance_profile.ecs_profile.name
  associate_public_ip_address = true
  key_name                    = aws_key_pair.vj_ec2_key.key_name

  tags = {
    Name = "ecs-instance-ubuntu"
  }
}
