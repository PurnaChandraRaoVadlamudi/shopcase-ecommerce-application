# ===================================================================
# IAM Outputs - Production Grade
# ===================================================================

# EKS Cluster Role
output "eks_cluster_role_arn" {
  description = "ARN of the EKS cluster role"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_cluster_role_name" {
  description = "Name of the EKS cluster role"
  value       = aws_iam_role.eks_cluster.name
}

# Public Node Group Role
output "eks_public_nodes_role_arn" {
  description = "ARN of the public nodes role"
  value       = aws_iam_role.eks_public_nodes.arn
}

output "eks_public_nodes_role_name" {
  description = "Name of the public nodes role"
  value       = aws_iam_role.eks_public_nodes.name
}

# Private Node Group Role
output "eks_private_nodes_role_arn" {
  description = "ARN of the private nodes role"
  value       = aws_iam_role.eks_private_nodes.arn
}

output "eks_private_nodes_role_name" {
  description = "Name of the private nodes role"
  value       = aws_iam_role.eks_private_nodes.name
}

# Stateful Node Group Role
output "eks_stateful_nodes_role_arn" {
  description = "ARN of the stateful nodes role"
  value       = aws_iam_role.eks_stateful_nodes.arn
}

output "eks_stateful_nodes_role_name" {
  description = "Name of the stateful nodes role"
  value       = aws_iam_role.eks_stateful_nodes.name
}

# GPU Node Group Role
output "eks_gpu_nodes_role_arn" {
  description = "ARN of the GPU nodes role"
  value       = aws_iam_role.eks_gpu_nodes.arn
}

output "eks_gpu_nodes_role_name" {
  description = "Name of the GPU nodes role"
  value       = aws_iam_role.eks_gpu_nodes.name
}

# Bastion Role
output "bastion_role_arn" {
  description = "ARN of the bastion role"
  value       = aws_iam_role.bastion.arn
}

output "bastion_role_name" {
  description = "Name of the bastion role"
  value       = aws_iam_role.bastion.name
}

# Admin Role
output "admin_role_arn" {
  description = "ARN of the admin role"
  value       = aws_iam_role.admin.arn
}

output "admin_role_name" {
  description = "Name of the admin role"
  value       = aws_iam_role.admin.name
}

# Developer Role
output "developer_role_arn" {
  description = "ARN of the developer role"
  value       = aws_iam_role.developer.arn
}

output "developer_role_name" {
  description = "Name of the developer role"
  value       = aws_iam_role.developer.name
}

# KMS Key
output "kms_key_id" {
  description = "KMS key ID"
  value       = aws_kms_key.this.key_id
}

output "kms_key_arn" {
  description = "KMS key ARN"
  value       = aws_kms_key.this.arn
}

output "kms_key_alias" {
  description = "KMS key alias"
  value       = aws_kms_alias.this.name
}