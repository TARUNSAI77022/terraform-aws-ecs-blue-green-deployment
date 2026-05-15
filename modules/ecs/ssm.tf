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
