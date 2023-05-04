locals {
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "aws-efs-csi-driver"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "batcave_efscsidriver" {

  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeMountTargets",
      "ec2:DescribeAvailabilityZones"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:CreateAccessPoint"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:TagResource"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["elasticfilesystem:DeleteAccessPoint"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

  statement {
    actions = [
      "elasticfilesystem:CreateAccessPoint",
      "elasticfilesystem:DeleteAccessPoint"
    ]
    resources = [
      "arn:aws:elasticfilesystem:*:${data.aws_caller_identity.current.account_id}:file-system/${aws_efs_file_system.efs.id}",
      "arn:aws:elasticfilesystem:*:${data.aws_caller_identity.current.account_id}:access-point/*"
    ]
  }

}
resource "aws_iam_policy" "batcave_efscsidriver" {
  name   = "efscsidriver-policy-${var.cluster_name}"
  path   = var.iam_path
  policy = data.aws_iam_policy_document.batcave_efscsidriver.json

}
module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  create_role                   = true
  role_name                     = "${var.cluster_name}-cluster-efscsidriver"
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.batcave_efscsidriver.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_service_account_namespace}:efs-csi-controller-sa", "system:serviceaccount:${local.k8s_service_account_namespace}:efs-csi-node-sa"]
  role_path                     = var.iam_path
  role_permissions_boundary_arn = var.permissions_boundary
}
