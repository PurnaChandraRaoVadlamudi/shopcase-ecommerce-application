module "vpc" {
  source = "./modules/vpc"

  env                 = var.env
  vpc_cidr            = var.vpc_cidr
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  database_subnets    = var.database_subnets
  availability_zones  = var.availability_zones
  cluster_name        = var.cluster_name
  allowed_cidr_blocks = var.allowed_cidr_blocks
}

module "iam" {
  source = "./modules/iam"

  env                 = var.env
  admin_principal_arn = var.admin_principal_arn
  dev_principal_arn   = var.dev_principal_arn
}

module "eks" {
  source = "./modules/eks"

  # Cluster Configuration
  cluster_name       = var.cluster_name
  cluster_role_arn   = module.iam.eks_cluster_role_arn
  kubernetes_version = var.kubernetes_version
  subnet_ids         = module.vpc.private_subnets
  primary_region     = var.region
  dr_region          = var.dr_region
  environment        = var.env

  # Network
  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access  = var.endpoint_public_access
  public_access_cidrs     = var.public_access_cidrs
  kms_key_arn           = module.iam.kms_key_arn
  authentication_logging  = var.authentication_logging

  # Public Node Group
  public_node_group_name = "${var.env}-public-nodes"
  public_node_role_arn   = module.iam.eks_public_nodes_role_arn
  public_subnet_ids      = module.vpc.public_subnets
  public_instance_types  = var.public_instance_types
  public_desired_size    = var.public_desired_size
  public_max_size        = var.public_max_size
  public_min_size        = var.public_min_size

  # Private Node Group
  private_node_group_name = "${var.env}-private-nodes"
  private_node_role_arn   = module.iam.eks_private_nodes_role_arn
  private_subnet_ids      = module.vpc.private_subnets
  private_instance_types  = var.private_instance_types
  private_desired_size    = var.private_desired_size
  private_max_size        = var.private_max_size
  private_min_size        = var.private_min_size

  # Stateful Node Group (Database)
  stateful_node_group_name = "${var.env}-stateful-nodes"
  stateful_node_role_arn   = module.iam.eks_stateful_nodes_role_arn
  stateful_subnet_ids      = module.vpc.database_subnets
  stateful_instance_types  = var.stateful_instance_types
  stateful_desired_size    = var.stateful_desired_size
  stateful_max_size        = var.stateful_max_size
  stateful_min_size        = var.stateful_min_size

  # GPU Node Group (AI/ML)
  gpu_node_group_name = "${var.env}-gpu-nodes"
  gpu_node_role_arn   = module.iam.eks_gpu_nodes_role_arn
  gpu_subnet_ids      = module.vpc.private_subnets
  gpu_instance_types  = var.gpu_instance_types
  gpu_desired_size    = var.gpu_desired_size
  gpu_max_size        = var.gpu_max_size
  gpu_min_size        = var.gpu_min_size

  # RBAC
  admin_role_arn = module.iam.admin_role_arn
  dev_role_arn   = module.iam.developer_role_arn
}

module "bastion" {
  source = "./modules/bastion"

  env                   = var.env
  subnet_id             = module.vpc.public_subnets[0]
  security_group_id     = module.vpc.bastion_security_group_id
  instance_type         = var.bastion_instance_type
  key_name              = var.bastion_key_name
  iam_role_name         = module.iam.bastion_role_name
  instance_profile_name = module.iam.bastion_role_name
}