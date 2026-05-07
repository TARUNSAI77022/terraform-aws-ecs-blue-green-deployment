output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "nat_gateway_public_ip" {
  description = "The Elastic IP address associated with the NAT Gateway"
  value       = module.vpc.nat_gateway_public_ip
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_target_group_arn" {
  description = "The ARN of the ALB Target Group"
  value       = module.alb.alb_target_group_arn
}

output "alb_security_group_id" {
  description = "The ID of the ALB Security Group"
  value       = module.alb.alb_security_group_id
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}
