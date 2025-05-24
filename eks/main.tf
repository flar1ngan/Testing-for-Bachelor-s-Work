provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
  map_public_ip_on_launch    = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name = var.cluster_name
  subnet_ids   = module.vpc.public_subnets
  vpc_id       = module.vpc.vpc_id

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    spot_nodes = {
      desired_size = 2
      min_size     = 2
      max_size     = 3

      instance_types = [var.node_instance_type]
      capacity_type  = "ON_DEMAND"

      labels = {
        type = "on-demand"
      }

      tags = {
        Name = "eks-on-demand-node"
        "k8s.io/cluster-autoscaler/enabled"          = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      }
    }
  }

  tags = {
    Environment = "test"
  }
}

module "cluster_autoscaler_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.34.0"

  role_name_prefix = "${var.cluster_name}-autoscaler"

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }
  
  role_policy_arns = {
    autoscaling = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  }
}