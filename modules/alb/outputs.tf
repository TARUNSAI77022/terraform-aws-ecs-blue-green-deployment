output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_target_group_arn" {
  description = "The ARN of the ALB Target Group"
  value       = aws_lb_target_group.main.arn
}

output "alb_security_group_id" {
  description = "The ID of the ALB Security Group"
  value       = aws_security_group.alb.id
}
