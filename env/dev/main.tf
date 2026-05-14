module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "alb" {
  source = "../../modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

module "ecs" {
  source = "../../modules/ecs"

  project_name       = var.project_name
  environment        = var.environment
  aws_region         = var.aws_region
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.public_subnet_ids

  container_name  = "app-container"
  container_port  = 80
  container_image = "${module.ecr.repository_url}:latest"
  desired_count   = 2
  cpu             = 256
  memory          = 512
  target_group_arn = module.alb.alb_target_group_blue_arn
}

module "codedeploy" {
  source = "../../modules/codedeploy"

  project_name            = var.project_name
  environment             = var.environment
  ecs_cluster_name        = module.ecs.ecs_cluster_name
  ecs_service_name        = module.ecs.ecs_service_name
  alb_listener_arn        = module.alb.alb_listener_arn
  blue_target_group_name  = module.alb.alb_target_group_blue_name
  green_target_group_name = module.alb.alb_target_group_green_name
}
