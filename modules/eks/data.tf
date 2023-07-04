data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "s3_sqs_policy_document" {
  statement {
    sid = "S3Access"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets"
    ]
    resources = [
      "arn:aws:s3:::*"
    ]
  }

  statement {
    sid = "SQSAccess"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
    ]
    resources = [
      "arn:aws:sqs:*:${data.aws_caller_identity.current.account_id}:*"
    ]
  }
}