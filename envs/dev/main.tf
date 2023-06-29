locals {
  app_name = "customer-info-app"
  env      = "dev"

  eks_managed_node_groups = {
    general = {
      desired_size = 2
      min_size     = 1
      max_size     = 2

      labels = {
        role = "general"
      }

      instance_types = ["t2.small"]
      capacity_type  = "ON_DEMAND"
    }
  }

  aws_auth_roles = [
    {
      rolearn  = module.eks_admins_iam_role.iam_role_arn
      username = module.eks_admins_iam_role.iam_role_name
      groups   = ["system:masters"]
    },
  ]
}

module "vpc" {
  source = "../../modules/vpc"

  env                = local.env
  name               = local.app_name
  azs                = ["ap-southeast-1a", "ap-southeast-1b"]
  cidr               = "20.0.0.0/16"
  private_subnets    = ["20.0.0.0/19", "20.0.32.0/19"]
  public_subnets     = ["20.0.64.0/19", "20.0.96.0/19"]
  enable_nat_gateway = true
  single_nat_gateway = true
}

module "eks" {
  source = "../../modules/eks"

  env                = local.env
  name               = local.app_name
  vpc_id = module.vpc.vpc_id
  vpc_owner_id = module.vpc.vpc_owner_id
  private_subnets = module.vpc.private_subnets
  public_subnets = module.vpc.public_subnets
  eks_managed_node_groups = local.eks_managed_node_groups
  aws_auth_roles = local.aws_auth_roles
}
