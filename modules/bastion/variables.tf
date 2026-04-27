# ===================================================================
# Bastion Variables - Production Grade
# ===================================================================

variable "env" {
  description = "Environment name (prod, staging, dev)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for bastion host (default: AL2 in ap-south-1)"
  type        = string
  default     = "ami-0b1c020a870a7d1e1"  # Amazon Linux 2 in ap-south-1
}

variable "instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.small"
}

variable "subnet_id" {
  description = "Subnet ID for bastion host"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for bastion host"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = ""
}

variable "instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
  default     = ""
}

variable "iam_role_name" {
  description = "IAM role name for bastion"
  type        = string
  default     = ""
}

variable "root_volume_type" {
  description = "Root volume type"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "enable_logging" {
  description = "Enable logging to S3"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}