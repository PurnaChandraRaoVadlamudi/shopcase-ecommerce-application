# ===================================================================
# EKS Cluster Variables - Production Grade with DR Support
# ===================================================================

# Cluster Configuration
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "cluster_timeout" {
  description = "Timeout for cluster operations"
  type        = string
  default     = "30m"
}

# Network Configuration
variable "subnet_ids" {
  description = "Subnet IDs for the EKS cluster"
  type        = list(string)
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
  description = "CIDR blocks for public access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Encryption
variable "kms_key_arn" {
  description = "KMS key ARN for encryption"
  type        = string
  default     = ""
}

# Logging
variable "authentication_logging" {
  description = "Enable authentication logging"
  type        = bool
  default     = true
}

# DR Configuration
variable "primary_region" {
  description = "Primary region for the cluster"
  type        = string
  default     = "us-east-1"
}

variable "dr_region" {
  description = "Disaster recovery region"
  type        = string
  default     = "us-west-2"
}

# Environment
variable "environment" {
  description = "Environment (prod, staging, dev)"
  type        = string
  default     = "prod"
}

# Tags
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "common_labels" {
  description = "Common labels for all node groups"
  type        = map(string)
  default     = {}
}

# ===================================================================
# Public Node Group Variables
# ===================================================================
variable "public_node_group_name" {
  description = "Name of the public node group"
  type        = string
  default     = "public-nodes"
}

variable "public_node_role_arn" {
  description = "IAM role ARN for public nodes"
  type        = string
}

variable "public_subnet_ids" {
  description = "Subnet IDs for public nodes"
  type        = list(string)
}

variable "public_instance_types" {
  description = "Instance types for public nodes"
  type        = list(string)
  default     = ["m5.large"]
}

variable "public_desired_size" {
  description = "Desired number of nodes in public node group"
  type        = number
  default     = 2
}

variable "public_max_size" {
  description = "Maximum number of nodes in public node group"
  type        = number
  default     = 4
}

variable "public_min_size" {
  description = "Minimum number of nodes in public node group"
  type        = number
  default     = 1
}

# ===================================================================
# Private Node Group Variables
# ===================================================================
variable "private_node_group_name" {
  description = "Name of the private node group"
  type        = string
  default     = "private-nodes"
}

variable "private_node_role_arn" {
  description = "IAM role ARN for private nodes"
  type        = string
}

variable "private_subnet_ids" {
  description = "Subnet IDs for private nodes"
  type        = list(string)
}

variable "private_instance_types" {
  description = "Instance types for private nodes"
  type        = list(string)
  default     = ["m5.xlarge"]
}

variable "private_desired_size" {
  description = "Desired number of nodes in private node group"
  type        = number
  default     = 2
}

variable "private_max_size" {
  description = "Maximum number of nodes in private node group"
  type        = number
  default     = 4
}

variable "private_min_size" {
  description = "Minimum number of nodes in private node group"
  type        = number
  default     = 1
}

# ===================================================================
# Stateful Node Group Variables (for Databases)
# ===================================================================
variable "stateful_node_group_name" {
  description = "Name of the stateful node group for databases"
  type        = string
  default     = "stateful-nodes"
}

variable "stateful_node_role_arn" {
  description = "IAM role ARN for stateful nodes"
  type        = string
}

variable "stateful_subnet_ids" {
  description = "Subnet IDs for stateful nodes"
  type        = list(string)
}

variable "stateful_instance_types" {
  description = "Instance types for stateful nodes (database workloads)"
  type        = list(string)
  default     = ["r5.xlarge"]
}

variable "stateful_desired_size" {
  description = "Desired number of nodes in stateful node group"
  type        = number
  default     = 2
}

variable "stateful_max_size" {
  description = "Maximum number of nodes in stateful node group"
  type        = number
  default     = 4
}

variable "stateful_min_size" {
  description = "Minimum number of nodes in stateful node group"
  type        = number
  default     = 1
}

# ===================================================================
# GPU Node Group Variables (for AI/ML Workloads)
# ===================================================================
variable "gpu_node_group_name" {
  description = "Name of the GPU node group for AI/ML workloads"
  type        = string
  default     = "gpu-nodes"
}

variable "gpu_node_role_arn" {
  description = "IAM role ARN for GPU nodes"
  type        = string
}

variable "gpu_subnet_ids" {
  description = "Subnet IDs for GPU nodes"
  type        = list(string)
}

variable "gpu_instance_types" {
  description = "Instance types for GPU nodes (AI/ML workloads)"
  type        = list(string)
  default     = ["g4dn.xlarge"]
}

variable "gpu_desired_size" {
  description = "Desired number of nodes in GPU node group"
  type        = number
  default     = 1
}

variable "gpu_max_size" {
  description = "Maximum number of nodes in GPU node group"
  type        = number
  default     = 2
}

variable "gpu_min_size" {
  description = "Minimum number of nodes in GPU node group"
  type        = number
  default     = 0
}

# ===================================================================
# RBAC / Authentication Variables
# ===================================================================
variable "admin_role_arn" {
  description = "IAM role ARN for cluster admin access"
  type        = string
  default     = ""
}

variable "dev_role_arn" {
  description = "IAM role ARN for developer access"
  type        = string
  default     = ""
}