output "subnet_id_a" {
  value = aws_subnet.subnet_a.id
}

output "subnet_id_b" {
  value = aws_subnet.subnet_b.id
}

output "security_group_id" {
  value = aws_security_group.ecs_security_group.id
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}