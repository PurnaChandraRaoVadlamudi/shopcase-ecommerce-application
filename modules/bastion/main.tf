# ===================================================================
# Bastion Host Module - Production Grade
# ===================================================================

resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  # Security
  vpc_security_group_ids = [var.security_group_id]
  key_name                = var.key_name

  # IAM Instance Profile
  iam_instance_profile = var.instance_profile_name

  # Root Volume
  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
    encrypted   = true
  }

  # Metadata Options
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  # Tags
  tags = merge(var.tags, {
    Name        = "${var.env}-bastion"
    Environment = var.env
    Role        = "bastion"
    ManagedBy   = "terraform"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IP for Bastion
resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.env}-bastion-eip"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Note: AMI is set via variable ami_id
# To get latest AL2 AMI: aws ssm get-parameters --names /aws/service/ami-amazon-linux-2/amzn2-ami-hvm-x86_64-gp2 --region ap-south-1

# CloudWatch Agent Config
resource "aws_s3_bucket" "bastion_logs" {
  count = var.enable_logging ? 1 : 0
  bucket = "${var.env}-bastion-logs-${data.aws_caller_identity.current.account_id}"

  tags = var.tags
}

data "aws_caller_identity" "current" {}

# IAM Instance Profile for Bastion
resource "aws_iam_instance_profile" "bastion" {
  name = "${var.env}-bastion-profile"
  role = var.iam_role_name

  tags = var.tags
}