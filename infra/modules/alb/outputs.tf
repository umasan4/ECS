output "load_balancer_arn" {
  value = aws_lb.frontend.arn
}

output "tg_arn" {
  value = aws_lb_target_group.ecs.arn
}

output "dns_name" {
  value = aws_lb.frontend.dns_name
}