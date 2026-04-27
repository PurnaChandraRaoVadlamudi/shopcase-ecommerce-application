# ===================================================================
# Terraform Backend Configuration
# ===================================================================
# 
# OPTION 1: Local State (for initial setup)
# Uncomment below and comment out S3 backend
#
# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }
#
# OPTION 2: S3 Backend (after bucket is created)
# 1. Create S3 bucket manually or via AWS Console
# 2. Ensure IAM credentials have s3:GetObject, s3:PutObject permissions
# 3. Uncomment below and run: terraform init
#
terraform {
  backend "s3" {
    bucket  = "purna-s3-bucket-77"
    key     = "infrastructure/dev/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}