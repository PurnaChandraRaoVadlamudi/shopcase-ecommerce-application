# EKS Cluster Module - Production Grade with DR Support

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
    subnet_ids              = var.subnet_ids
  }

  # Encryption configuration with KMS key
  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = var.kms_key_arn
    }
  }

  # Enable logging via CloudWatch
  enabled_cluster_log_types = var.authentication_logging ? ["api", "audit", "authenticator", "controllerManager", "scheduler"] : []

  timeouts {
    create = var.cluster_timeout
    update = var.cluster_timeout
    delete = var.cluster_timeout
  }

  tags = var.tags
}

# Kubernetes Cluster Auth (data source for kubeconfig)
data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

# Node Group: Public Nodes
resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.public_node_group_name
  node_role_arn   = var.public_node_role_arn
  subnet_ids      = var.public_subnet_ids
  instance_types  = var.public_instance_types

  scaling_config {
    desired_size = var.public_desired_size
    max_size     = var.public_max_size
    min_size     = var.public_min_size
  }

  labels = merge(var.common_labels, {
    "node-group" = "public"
    "workload"   = "general"
  })

  taint {
    key    = "node-group"
    value = "public"
    effect = "NO_SCHEDULE"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config]
  }

  tags = var.tags
}

# Node Group: Private Nodes
resource "aws_eks_node_group" "private" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.private_node_group_name
  node_role_arn   = var.private_node_role_arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.private_instance_types

  scaling_config {
    desired_size = var.private_desired_size
    max_size     = var.private_max_size
    min_size     = var.private_min_size
  }

  labels = merge(var.common_labels, {
    "node-group" = "private"
    "workload"   = "general"
  })

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config]
  }

  tags = var.tags
}

# Node Group: Stateful Nodes (for Databases)
resource "aws_eks_node_group" "stateful" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.stateful_node_group_name
  node_role_arn   = var.stateful_node_role_arn
  subnet_ids      = var.stateful_subnet_ids
  instance_types  = var.stateful_instance_types

  scaling_config {
    desired_size = var.stateful_desired_size
    max_size     = var.stateful_max_size
    min_size     = var.stateful_min_size
  }

  labels = merge(var.common_labels, {
    "node-group" = "stateful"
    "workload"   = "database"
  })

  taint {
    key    = "workload"
    value = "stateful"
    effect = "NO_SCHEDULE"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config]
  }

  tags = var.tags
}

# Node Group: GPU Nodes (for AI/ML Workloads)
resource "aws_eks_node_group" "gpu" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.gpu_node_group_name
  node_role_arn   = var.gpu_node_role_arn
  subnet_ids      = var.gpu_subnet_ids
  instance_types  = var.gpu_instance_types

  scaling_config {
    desired_size = var.gpu_desired_size
    max_size     = var.gpu_max_size
    min_size     = var.gpu_min_size
  }

  labels = merge(var.common_labels, {
    "node-group" = "gpu"
    "workload"   = "ai-ml"
  })

  taint {
    key    = "workload"
    value = "gpu"
    effect = "NO_SCHEDULE"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config]
  }

  tags = var.tags
}

# Note: ConfigMaps should be applied manually after cluster creation
# Use: kubectl apply -f https://raw.githubusercontent.com/aws/eks-charts/master/stable/aws-load-balancer-controller/docs/config/maps/eks-cluster.yaml
# Or use AWS Console > EKS > Add-ons > AWS Load Balancer Controller

# Output cluster config for manual ConfigMap application
output "aws_auth_configmap_yaml" {
  description = "aws-auth ConfigMap YAML - apply manually after cluster creation"
  value       = <<-YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${var.public_node_role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: ${var.private_node_role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: ${var.stateful_node_role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: ${var.gpu_node_role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: ${var.admin_role_arn}
      username: admin
      groups:
        - system:masters
    - rolearn: ${var.dev_role_arn}
      username: developer
      groups:
        - system:masters
  YAML
  sensitive = true
}