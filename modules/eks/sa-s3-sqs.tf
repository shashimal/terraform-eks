module "iam_eks_s3_sqs_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "eks-s3-sqs-access"

  role_policy_arns = {
    policy = aws_iam_policy.eks_s3_sqs_access.arn
  }

  oidc_providers = {
    one = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${local.service_account_namespace}:${local.service_account_s3_sqs}"]
    }
  }
}

resource "aws_iam_policy" "eks_s3_sqs_access" {
  name = "eks-s3-sqs-access"
  policy = data.aws_iam_policy_document.s3_sqs_policy_document.json
}

resource "kubernetes_service_account" "iam_role_s3_sqs" {
  metadata {
    name      = local.service_account_s3_sqs
    namespace = local.service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_eks_s3_sqs_role.iam_role_arn
    }
  }
}