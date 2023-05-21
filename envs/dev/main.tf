locals {
  app_name = "simple-eks-app"
  env      = "dev"
}

module "vpc" {
  source = "../../modules/vpc"

  env                = local.env
  name               = local.app_name
  azs                = ["us-east-1a", "us-east-1b"]
  cidr               = "20.0.0.0/16"
  private_subnets    = ["20.0.0.0/19", "20.0.32.0/19"]
  public_subnets     = ["20.0.64.0/19", "20.0.96.0/19"]
  enable_nat_gateway = true
  single_nat_gateway = true
}
