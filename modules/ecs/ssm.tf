resource "aws_ssm_parameter" "mongo_uri" {
  name        = "/${var.project_name}/${var.environment}/MONGO_URI"
  description = "MongoDB Connection URI"
  type        = "SecureString"
  value       = var.mongo_uri

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "jwt_secret" {
  name        = "/${var.project_name}/${var.environment}/JWT_SECRET"
  description = "JWT Secret Key"
  type        = "SecureString"
  value       = var.jwt_secret

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "port" {
  name        = "/${var.project_name}/${var.environment}/PORT"
  description = "Application port"
  type        = "SecureString"
  value       = tostring(var.port)

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "node_env" {
  name        = "/${var.project_name}/${var.environment}/NODE_ENV"
  description = "Node environment"
  type        = "SecureString"
  value       = var.node_env

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "base_url" {
  name        = "/${var.project_name}/${var.environment}/BASE_URL"
  description = "Backend Base URL"
  type        = "SecureString"
  value       = var.base_url

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "frontend_url" {
  name        = "/${var.project_name}/${var.environment}/FRONTEND_URL"
  description = "Frontend Application URL"
  type        = "SecureString"
  value       = var.frontend_url

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
