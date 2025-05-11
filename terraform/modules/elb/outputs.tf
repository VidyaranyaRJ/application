# output "aws_elb_alb_test_name" {
#   value = aws_elb.app_alb.name
# }


output "tg_arn" {
  value = aws_lb_target_group.app_tg.arn
}