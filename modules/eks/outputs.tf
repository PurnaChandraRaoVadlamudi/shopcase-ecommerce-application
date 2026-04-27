# ===================================================================
# EKS Cluster Outputs - Production Grade with DR Support
# ===================================================================

# Cluster Outputs
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_version" {
  description = "Kubernetes version of the cluster"
  value       = aws_eks_cluster.this.version
}

output "cluster_security_group_id" {
  description = "Security group ID for the cluster"
  value       = aws_eks_cluster.this.vpc_config[0].security_group_ids
}

output "cluster_certificate_authority_data" {
  description = "Certificate authority data for the cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
  sensitive   = true
}

# Public Node Group Outputs
output "public_node_group_name" {
  description = "Name of the public node group"
  value       = aws_eks_node_group.public.id
}

output "public_node_group_arn" {
  description = "ARN of the public node group"
  value       = aws_eks_node_group.public.arn
}

# Private Node Group Outputs
output "private_node_group_name" {
  description = "Name of the private node group"
  value       = aws_eks_node_group.private.id
}

output "private_node_group_arn" {
  description = "ARN of the private node group"
  value       = aws_eks_node_group.private.arn
}

# Stateful Node Group Outputs
output "stateful_node_group_name" {
  description = "Name of the stateful node group"
  value       = aws_eks_node_group.stateful.id
}

output "stateful_node_group_arn" {
  description = "ARN of the stateful node group"
  value       = aws_eks_node_group.stateful.arn
}

# GPU Node Group Outputs
output "gpu_node_group_name" {
  description = "Name of the GPU node group"
  value       = aws_eks_node_group.gpu.id
}

output "gpu_node_group_arn" {
  description = "ARN of the GPU node group"
  value       = aws_eks_node_group.gpu.arn
}

# DR Configuration Outputs
output "primary_region" {
  description = "Primary region"
  value       = var.primary_region
}

output "dr_region" {
  description = "Disaster recovery region"
  value       = var.dr_region
}

output "environment" {
  description = "Environment"
  value       = var.environment
}