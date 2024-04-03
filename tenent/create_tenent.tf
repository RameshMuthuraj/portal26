// Terraform script for creating a new tenant

provider "aws" {
  region = "your_region"
}

// Update IAM role for EKS worker nodes to allow access to AWS Secrets Manager

// Create resources for the new tenant
resource "aws_secretsmanager_secret" "db_credentials" {
  name = "portal26-${var.tenant_name}-db-credentials"
  // Add other secret configurations as needed
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "db_user"
    password = "db_password"
    url      = "db_url"
    // Add other database connection details as needed
  })
}

resource "aws_s3_bucket" "tenant_bucket" {
  bucket = "portal26_${var.tenant_name}"
  // Add other bucket configurations as needed
}

resource "aws_route53_record" "cname_record" {
  zone_id = "your_zone_id"
  name    = "i_${var.tenant_name}.arcstone.ai"
  type    = "CNAME"
  ttl     = "300"
  records = ["<<address>>:8080"]
}