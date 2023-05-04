locals {
  k8s_service_account_namespace   = "kube-system"
  controller_service_account_name = "efs-csi-controller-sa"
  node_service_account_name       = "efs-csi-node-sa"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "batcave_efscsidriver" {
  # Allow EFS access
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
  # Allow creating EFS access points with specific tags
  statement {
    effect    = "Allow"
    actions   = [
      "elasticfilesystem:CreateAccessPoint",
      "elasticfilesystem:TagResource"
      ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
  # Allow deleting EFS access points with specific tags
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
  # Allow creating and deleting EFS resources with specific ARNs
  statement {
    effect = "Allow"
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
  source           = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  create_role      = true
  role_name        = "${var.cluster_name}-cluster-efscsidriver"
  provider_url     = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns = [aws_iam_policy.batcave_efscsidriver.arn]
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:${local.k8s_service_account_namespace}:${local.controller_service_account_name}",
    "system:serviceaccount:${local.k8s_service_account_namespace}:${local.node_service_account_name}"
  ]
  role_path                     = var.iam_path
  role_permissions_boundary_arn = var.permissions_boundary
}
