terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.env
      ManagedBy   = "terraform"
    }
  }
}

# ===================================================================
# Remote State S3 Bucket (using existing bucket)
# Note: Using existing bucket "purna-s3-bucket-77" for state storage
# Bucket resources removed - using user's existing bucket
# ===================================================================