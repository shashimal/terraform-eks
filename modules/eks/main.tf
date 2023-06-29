module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name = "${var.name}-${var.env}"
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 20
  }

  eks_managed_node_groups = var.eks_managed_node_groups

  manage_aws_auth_configmap = true
  aws_auth_roles = var.aws_auth_roles
  iam_role_additional_policies = {
    additional = aws_iam_policy.additional.arn
  }
}

resource "aws_iam_policy" "additional" {
  name = "eks-additional-policies"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
