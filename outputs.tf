# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = module.vpc.vpc_cidr
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "database_subnets" {
  description = "Database subnet IDs"
  value       = module.vpc.database_subnets
}

output "cluster_security_group_id" {
  description = "Cluster security group ID"
  value       = module.vpc.cluster_security_group_id
}

output "node_security_group_id" {
  description = "Node security group ID"
  value       = module.vpc.node_security_group_id
}

output "bastion_security_group_id" {
  description = "Bastion security group ID"
  value       = module.vpc.bastion_security_group_id
}

# IAM Outputs
output "eks_cluster_role_arn" {
  description = "EKS cluster role ARN"
  value       = module.iam.eks_cluster_role_arn
}

output "eks_public_nodes_role_arn" {
  description = "EKS public nodes role ARN"
  value       = module.iam.eks_public_nodes_role_arn
}

output "eks_private_nodes_role_arn" {
  description = "EKS private nodes role ARN"
  value       = module.iam.eks_private_nodes_role_arn
}

output "eks_stateful_nodes_role_arn" {
  description = "EKS stateful nodes role ARN"
  value       = module.iam.eks_stateful_nodes_role_arn
}

output "eks_gpu_nodes_role_arn" {
  description = "EKS GPU nodes role ARN"
  value       = module.iam.eks_gpu_nodes_role_arn
}

output "bastion_role_arn" {
  description = "Bastion role ARN"
  value       = module.iam.bastion_role_arn
}

output "kms_key_id" {
  description = "KMS key ID"
  value       = module.iam.kms_key_id
}

# EKS Outputs
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS cluster version"
  value       = module.eks.cluster_version
}

output "public_node_group_name" {
  description = "Public node group name"
  value       = module.eks.public_node_group_name
}

output "private_node_group_name" {
  description = "Private node group name"
  value       = module.eks.private_node_group_name
}

output "stateful_node_group_name" {
  description = "Stateful node group name"
  value       = module.eks.stateful_node_group_name
}

output "gpu_node_group_name" {
  description = "GPU node group name"
  value       = module.eks.gpu_node_group_name
}

# Bastion Outputs
output "bastion_public_ip" {
  description = "Bastion public IP"
  value       = module.bastion.bastion_public_ip
}

output "bastion_private_ip" {
  description = "Bastion private IP"
  value       = module.bastion.bastion_private_ip
}