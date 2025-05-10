# Create a new load balancer
resource "aws_elb" "elb_test" {
  name               = var.elb_name
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

  access_logs {
    bucket        = "vj-test-ecr-79"
    bucket_prefix = "elb-logs"
    interval      = 60
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }



  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  # instances                   = [var.instance_id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }
}
