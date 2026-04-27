# Infrastructure Terraform Module

Production-grade AWS infrastructure using Terraform with EKS cluster, VPC, IAM, and Bastion host.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            AWS Cloud                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                           VPC (10.0.0.0/16)                         │    │
│  │  ┌─────────────────────────────────────────────────────────────────┐│    │
│  │  │                     Public Subnets (3 AZs)                      ││    │
│  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐                       ││    │
│  │  │  │Public Subnet│ │Public Subnet│ │Public Subnet│                ││    │
│  │  │  │ 10.0.1.0/24│ │ 10.0.2.0/24│ │ 10.0.3.0/24│                ││    │
│  │  │  │   AZ a    │  │   AZ b    │  │   AZ c    │                ││    │
│  │  │  └────┬─────┘  └────┬─────┘  └────┬─────┘                       ││    │
│  │  │       │             │             │                             ││    │
│  │  │  ┌────┴─────────────┴─────────────┴────┐                       ││    │
│  │  │  │         Internet Gateway            │                       ││    │
│  │  │  └─────────────────────────────────────┘                       ││    │
│  │  └─────────────────────────────────────────────────────────────────┘│    │
│  │                                    │                                   │    │
│  │  ┌─────────────────────────────────┴─────────────────────────────────┐│    │
│  │  │                    NAT Gateways (3 AZs)                         ││    │
│  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐                       ││    │
│  │  │  │ NAT GW 1 │  │ NAT GW 2 │  │ NAT GW 3 │                       ││    │
│  │  │  │ (AZ a)   │  │ (AZ b)   │  │ (AZ c)   │                       ││    │
│  │  │  └──────────┘  └──────────┘  └──────────┘                       ││    │
│  │  └───────────────────────────────────────────────────────────────────┘│    │
│  │                                    │                                   │    │
│  │  ┌─────────────────────────────────────────────────────────────────┐│    │
│  │  │                    Private Subnets (3 AZs)                     ││    │
│  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐                       ││    │
│  │  │  │Private Sub│ │Private Sub│ │Private Sub│                ││    │
│  │  │  │10.0.11.0/24││10.0.12.0/24││10.0.13.0/24│               ││    │
│  │  │  │   AZ a    │  │   AZ b    │  │   AZ c    │                ││    │
│  │  │  └──────────┘  └──────────┘  └──────────┘                       ││    │
│  │  │       │             │             │                             ││    │
│  │  │       └─────────────┴─────────────┘                             ││    │
│  │  │              │           │           │                           ││    │
│  │  │  ┌──────────┴──────────┴──────────┴──────────┐                 ││    │
│  │  │  │              EKS Cluster                   │                 ││    │
│  │  │  │  ┌──────────────────────────────────────┐  │                 ││    │
│  │  │  │  │     Node Groups (4 types)           │  │                 ││    │
│  │  │  │  │  • Public Nodes (m5.large)          │  │                 ││    │
│  │  │  │  │  • Private Nodes (m5.xlarge)        │  │                 ││    │
│  │  │  │  │  • Stateful Nodes (r5.xlarge)       │  │                 ││    │
│  │  │  │  │  • GPU Nodes (g4dn.xlarge)          │  │                 ││    │
│  │  │  │  └──────────────────────────────────────┘  │                 ││    │
│  │  │  └───────────────────────────────────────────┘                 ││    │
│  │  └─────────────────────────────────────────────────────────────────┘│    │
│  │                                    │                                   │    │
│  │  ┌─────────────────────────────────────────────────────────────────┐│    │
│  │  │                   Database Subnets (3 AZs)                     ││    │
│  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐                       ││    │
│  │  │  │Database Sub│ │Database Sub│ │Database Sub│               ││    │
│  │  │  │10.0.21.0/24││10.0.22.0/24││10.0.23.0/24│               ││    │
│  │  │  │   AZ a    │  │   AZ b    │  │   AZ c    │                ││    │
│  │  │  └──────────┘  └──────────┘  └──────────┘                       ││    │
│  │  └─────────────────────────────────────────────────────────────────┘│    │
│  │                                                                         │
│  │  ┌─────────────────────────────────────────────────────────────────┐  │
│  │  │                      Bastion Host                                │  │
│  │  │  ┌──────────┐                                                    │  │
│  │  │  │  t3.small│  →  SSH Access (Port 22)                          │  │
│  │  │  │ Public IP│  →  SSM Session Manager                           │  │
│  │  │  └──────────┘                                                    │  │
│  │  └─────────────────────────────────────────────────────────────────┘  │
│  │                                                                         │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## File Structure

```
01.infrastructure/
├── main.tf          # Root module - calls all sub-modules
├── variables.tf    # Input variables for the infrastructure
├── outputs.tf      # Output values after deployment
├── version.tf      # Terraform & provider versions, S3 bucket config
├── backend.tf      # Remote state configuration (S3)
├── dev.tfvars      # Development environment variables
├── test.tfvars     # Test environment variables
├── .gitignore      # Git ignore rules
│
└── modules/
    ├── vpc/        # VPC, Subnets, NAT Gateways, Route Tables
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── iam/        # IAM Roles & Policies for EKS
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── eks/        # EKS Cluster & Node Groups
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── bastion/    # Bastion Host for SSH access
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Step-by-Step Deployment Guide

### Step 1: Initialize Terraform

```bash
cd 01.infrastructure
terraform init
```

**What happens:**
- Downloads AWS provider (hashicorp/aws ~> 5.0)
- Initializes S3 backend for state storage
- Downloads module configurations

---

### Step 2: Validate Configuration

```bash
terraform validate
```

**What happens:**
- Checks Terraform syntax
- Validates resource configurations
- Ensures all required variables are defined

---

### Step 3: Plan Infrastructure

```bash
# For development environment
terraform plan -var-file="dev.tfvars"

# For test environment
terraform plan -var-file="test.tfvars"
```

**What happens:**
- Shows all resources that will be created
- Displays execution plan
- No changes are made yet

---

### Step 4: Apply Infrastructure

```bash
# For development environment
terraform apply -var-file="dev.tfvars"

# For test environment
terraform apply -var-file="test.tfvars"
```

**What happens:**
- Creates all resources in order
- Shows progress for each resource
- Outputs final values after completion

---

## Component Details

### 1. VPC (Virtual Private Cloud)

**File:** `modules/vpc/main.tf`

```hcl
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}
```

**What it does:**
- Creates isolated network environment
- CIDR block: `10.0.0.0/16` (65,536 IP addresses)
- Enables DNS hostname assignment
- Enables DNS support

**Subnets created:**

| Subnet Type | CIDR | AZs | Purpose |
|-------------|------|-----|---------|
| Public | 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 | 3 | Internet-facing resources |
| Private | 10.0.11.0/24, 10.0.12.0/24, 10.0.13.0/24 | 3 | Internal applications |
| Database | 10.0.21.0/24, 10.0.22.0/24, 10.0.23.0/24 | 3 | Databases & stateful workloads |

**NAT Gateways:**

```hcl
resource "aws_nat_gateway" "this" {
  count = length(var.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}
```

**What it does:**
- Creates 3 NAT Gateways (one per AZ for high availability)
- Allows private subnet resources to access internet
- Prevents inbound internet traffic to private resources
- Each NAT Gateway has its own Elastic IP

**Route Tables:**

| Route Table | Destination | Target |
|-------------|-------------|--------|
| Public | 0.0.0.0/0 | Internet Gateway |
| Private | 0.0.0.0/0 | NAT Gateway (AZ-specific) |
| Database | 0.0.0.0/0 | NAT Gateway (AZ-specific) |

**Security Groups:**

| Security Group | Purpose |
|----------------|---------|
| Cluster Control Plane | EKS cluster API access |
| Node Group | Worker node communication |
| Bastion | SSH access to bastion host |

---

### 2. IAM (Identity & Access Management)

**File:** `modules/iam/main.tf`

**IAM Roles Created:**

| Role Name | Purpose | Attached Policies |
|-----------|---------|-------------------|
| `<env>-eks-cluster-role` | EKS Cluster | AmazonEKSClusterPolicy, AmazonEKSServicePolicy, AmazonEKS_CNI_Policy |
| `<env>-eks-public-nodes-role` | Public Node Group | AmazonEKSWorkerNodePolicy, AmazonEKS_CNI_Policy, AmazonEC2ContainerRegistryReadOnly |
| `<env>-eks-private-nodes-role` | Private Node Group | AmazonEKSWorkerNodePolicy, AmazonEKS_CNI_Policy, AmazonEC2ContainerRegistryReadOnly |
| `<env>-eks-stateful-nodes-role` | Stateful Node Group (DB) | AmazonEKSWorkerNodePolicy, AmazonEKS_CNI_Policy, AmazonEC2ContainerRegistryReadOnly, AmazonEBSCSIDriverPolicy |
| `<env>-eks-gpu-nodes-role` | GPU Node Group (AI/ML) | AmazonEKSWorkerNodePolicy, AmazonEKS_CNI_Policy, AmazonEC2ContainerRegistryReadOnly, AmazonSageMakerFullAccess |
| `<env>-bastion-role` | Bastion Host | AmazonSSMManagedInstanceCore, CloudWatchAgentServerPolicy |
| `<env>-admin-role` | Admin Access | AmazonEKSClusterPolicy, AdministratorAccess |
| `<env>-developer-role` | Developer Access | AmazonEKSClusterPolicy, ReadOnlyAccess |

**KMS Key:**

```hcl
resource "aws_kms_key" "this" {
  description             = "${var.env}-eks-kms-key"
  deletion_window_in_days = 10
  enable_key_rotation      = true
}
```

**What it does:**
- Creates KMS key for EKS secret encryption
- Enables key rotation (automatic key rotation)
- 10-day deletion window

---

### 3. EKS (Elastic Kubernetes Service)

**File:** `modules/eks/main.tf`

**Cluster Configuration:**

```hcl
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = var.subnet_ids
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = var.kms_key_arn
    }
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}
```

**What it does:**
- Creates EKS cluster with specified name
- Associates IAM role for cluster operations
- Enables both private and public endpoint access
- Encrypts secrets using KMS key
- Enables comprehensive logging

**Node Groups (4 types):**

#### 3.1 Public Node Group

```hcl
resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "dev-public-nodes"
  instance_types  = ["m5.large"]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  taint {
    key    = "node-group"
    value = "public"
    effect = "NO_SCHEDULE"
  }
}
```

| Property | Value |
|----------|-------|
| Instance Type | m5.large |
| Desired Size | 2 |
| Max Size | 4 |
| Min Size | 1 |
| Use Case | General workloads, web servers |

#### 3.2 Private Node Group

```hcl
resource "aws_eks_node_group" "private" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "dev-private-nodes"
  instance_types  = ["m5.xlarge"]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }
}
```

| Property | Value |
|----------|-------|
| Instance Type | m5.xlarge |
| Desired Size | 2 |
| Max Size | 4 |
| Min Size | 1 |
| Use Case | Internal services, APIs |

#### 3.3 Stateful Node Group (Database)

```hcl
resource "aws_eks_node_group" "stateful" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "dev-stateful-nodes"
  instance_types  = ["r5.xlarge"]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  taint {
    key    = "workload"
    value = "stateful"
    effect = "NO_SCHEDULE"
  }
}
```

| Property | Value |
|----------|-------|
| Instance Type | r5.xlarge (Memory optimized) |
| Desired Size | 2 |
| Max Size | 4 |
| Min Size | 1 |
| Use Case | Databases, Redis, Cassandra |
| Taint | No schedule - requires explicit toleration |

#### 3.4 GPU Node Group (AI/ML)

```hcl
resource "aws_eks_node_group" "gpu" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "dev-gpu-nodes"
  instance_types  = ["g4dn.xlarge"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 0
  }

  taint {
    key    = "workload"
    value = "gpu"
    effect = "NO_SCHEDULE"
  }
}
```

| Property | Value |
|----------|-------|
| Instance Type | g4dn.xlarge (GPU - NVIDIA T4) |
| Desired Size | 1 |
| Max Size | 2 |
| Min Size | 0 |
| Use Case | Machine learning, AI workloads, GPU computing |
| Taint | No schedule - requires explicit toleration |

---

### 4. Bastion Host

**File:** `modules/bastion/main.tf`

```hcl
resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = "t3.small"
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.instance_profile_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  domain   = "vpc"
}
```

**What it does:**
- Creates EC2 instance in public subnet
- Attaches security group for SSH access
- Enables SSM Session Manager for passwordless SSH
- Assigns Elastic IP for persistent public access

| Property | Value |
|----------|-------|
| Instance Type | t3.small |
| AMI | Amazon Linux 2 |
| Access | SSH (port 22) + SSM Session Manager |
| Security | Security group with restricted CIDR |

---

## Variables Reference

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `region` | AWS region | `ap-south-1` |
| `env` | Environment name | `dev`, `test`, `prod` |
| `cluster_name` | EKS cluster name | `dev-eks-cluster` |

### Optional Variables (with defaults)

| Variable | Default | Description |
|----------|---------|-------------|
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR block |
| `kubernetes_version` | `1.28` | Kubernetes version |
| `dr_region` | `us-west-2` | Disaster recovery region |
| `public_instance_types` | `["m5.large"]` | Public node instance types |
| `private_instance_types` | `["m5.xlarge"]` | Private node instance types |
| `stateful_instance_types` | `["r5.xlarge"]` | Stateful node instance types |
| `gpu_instance_types` | `["g4dn.xlarge"]` | GPU node instance types |
| `bastion_instance_type` | `t3.small` | Bastion instance type |

---

## Outputs Reference

### VPC Outputs

| Output | Description |
|--------|-------------|
| `vpc_id` | VPC ID |
| `vpc_cidr` | VPC CIDR block |
| `public_subnets` | Public subnet IDs |
| `private_subnets` | Private subnet IDs |
| `database_subnets` | Database subnet IDs |
| `cluster_security_group_id` | Cluster security group ID |
| `node_security_group_id` | Node security group ID |
| `bastion_security_group_id` | Bastion security group ID |

### IAM Outputs

| Output | Description |
|--------|-------------|
| `eks_cluster_role_arn` | EKS cluster IAM role ARN |
| `eks_public_nodes_role_arn` | Public nodes IAM role ARN |
| `eks_private_nodes_role_arn` | Private nodes IAM role ARN |
| `eks_stateful_nodes_role_arn` | Stateful nodes IAM role ARN |
| `eks_gpu_nodes_role_arn` | GPU nodes IAM role ARN |
| `kms_key_id` | KMS key ID |
| `kms_key_arn` | KMS key ARN |

### EKS Outputs

| Output | Description |
|--------|-------------|
| `eks_cluster_name` | EKS cluster name |
| `eks_cluster_endpoint` | EKS cluster API server endpoint |
| `eks_cluster_version` | Kubernetes version |
| `public_node_group_name` | Public node group name |
| `private_node_group_name` | Private node group name |
| `stateful_node_group_name` | Stateful node group name |
| `gpu_node_group_name` | GPU node group name |

### Bastion Outputs

| Output | Description |
|--------|-------------|
| `bastion_public_ip` | Bastion public IP address |
| `bastion_private_ip` | Bastion private IP address |

---

## Disaster Recovery (DR) Configuration

The infrastructure is designed for DR with:

1. **Multi-AZ Deployment**: All subnets spread across 3 Availability Zones
2. **DR Region**: Configurable `dr_region` variable for cross-region replication
3. **Node Group Isolation**: Each node type in separate subnets for fault isolation

```hcl
# In dev.tfvars
dr_region = "us-west-2"
primary_region = "ap-south-1"
```

---

## Security Best Practices

1. **Network Isolation**: Public, private, and database subnets separated
2. **Encryption at Rest**: KMS key encryption for EKS secrets
3. **Secure Access**: SSM Session Manager instead of SSH (when possible)
4. **IAM Least Privilege**: Specific policies for each role
5. **Logging**: CloudWatch logging for all API operations
6. **Security Groups**: Restricted inbound access

---

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| `AccessDeniedException` for SSM | Use AMI ID variable instead of SSM data source |
| State lock error | Ensure no concurrent terraform runs |
| Node group creation fails | Check IAM role policies are attached |
| VPC creation fails | Check CIDR block doesn't overlap with existing VPCs |

### Useful Commands

```bash
# View state
terraform show

# List resources
terraform state list

# Debug
TF_LOG=DEBUG terraform plan -var-file="dev.tfvars"

# Destroy specific resource
terraform destroy -target=aws_eks_cluster.this
```

---

## License

This infrastructure code is provided as-is for AWS cloud infrastructure deployment.