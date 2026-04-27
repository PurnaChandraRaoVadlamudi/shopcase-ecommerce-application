variable "region" {
  description = "AWS region"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

# VPC Configuration
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "database_subnets" {
  description = "Database subnet CIDRs"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "allowed_cidr_blocks" {
  description = "Allowed CIDR blocks for bastion"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

# EKS Configuration
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "dr_region" {
  description = "DR region for disaster recovery"
  type        = string
  default     = "us-west-2"
}

variable "endpoint_private_access" {
  description = "Enable private endpoint access"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public endpoint access"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "Public access CIDR blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "authentication_logging" {
  description = "Enable authentication logging"
  type        = bool
  default     = true
}

# Node Group Configuration
variable "public_instance_types" {
  description = "Public node instance types"
  type        = list(string)
  default     = ["m5.large"]
}

variable "public_desired_size" {
  description = "Public node desired size"
  type        = number
  default     = 2
}

variable "public_max_size" {
  description = "Public node max size"
  type        = number
  default     = 4
}

variable "public_min_size" {
  description = "Public node min size"
  type        = number
  default     = 1
}

variable "private_instance_types" {
  description = "Private node instance types"
  type        = list(string)
  default     = ["m5.xlarge"]
}

variable "private_desired_size" {
  description = "Private node desired size"
  type        = number
  default     = 2
}

variable "private_max_size" {
  description = "Private node max size"
  type        = number
  default     = 4
}

variable "private_min_size" {
  description = "Private node min size"
  type        = number
  default     = 1
}

variable "stateful_instance_types" {
  description = "Stateful node instance types (database)"
  type        = list(string)
  default     = ["r5.xlarge"]
}

variable "stateful_desired_size" {
  description = "Stateful node desired size"
  type        = number
  default     = 2
}

variable "stateful_max_size" {
  description = "Stateful node max size"
  type        = number
  default     = 4
}

variable "stateful_min_size" {
  description = "Stateful node min size"
  type        = number
  default     = 1
}

variable "gpu_instance_types" {
  description = "GPU node instance types (AI/ML)"
  type        = list(string)
  default     = ["g4dn.xlarge"]
}

variable "gpu_desired_size" {
  description = "GPU node desired size"
  type        = number
  default     = 1
}

variable "gpu_max_size" {
  description = "GPU node max size"
  type        = number
  default     = 2
}

variable "gpu_min_size" {
  description = "GPU node min size"
  type        = number
  default     = 0
}

# Bastion Configuration
variable "bastion_instance_type" {
  description = "Bastion instance type"
  type        = string
  default     = "t3.small"
}

variable "bastion_key_name" {
  description = "Bastion SSH key name"
  type        = string
  default     = ""
}

# IAM Configuration
variable "admin_principal_arn" {
  description = "Admin principal ARN"
  type        = string
  default     = ""
}

variable "dev_principal_arn" {
  description = "Developer principal ARN"
  type        = string
  default     = ""
}