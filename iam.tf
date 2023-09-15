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
    effect = "Allow"
    actions = [
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


data "aws_iam_policy_document" "vault_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "backup:DeleteBackupVault",
      "backup:DeleteBackupVaultAccessPolicy",
      "backup:DeleteRecoveryPoint",
      "backup:StartCopyJob",
      "backup:StartRestoreJob",
      "backup:UpdateRecoveryPointLifecycle"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.efs_backup_restore_role.arn]
    }
  }
}

# Adding this because a bug in the provider is causing implicit dependencies to not be enough
# Explict dependencies also don't work
# See https://github.com/hashicorp/terraform-provider-aws/issues/33173
# Once this bug if fixed we can delete both this resource block along with the depends_on on the vault policy below
resource "time_sleep" "iam_delay" {
  depends_on      = [aws_iam_role.efs_backup_restore_role]
  create_duration = "20s"
}

resource "aws_backup_vault_policy" "efs_backup_vault" {
  depends_on        = [time_sleep.iam_delay]
  backup_vault_name = aws_backup_vault.daily.name
  policy            = data.aws_iam_policy_document.vault_policy.json
}

data "aws_iam_policy_document" "backup_efs_policy" {
  statement {
    effect    = "Allow"
    resources = [aws_efs_file_system.efs.arn]

    actions = [
      "elasticfilesystem:Restore",
      "elasticfilesystem:CreateFilesystem",
      "elasticfilesystem:DescribeFilesystems",
      "elasticfilesystem:DeleteFilesystem",
    ]
  }

  statement {
    effect    = "Allow"
    resources = [data.aws_kms_key.efs.arn]

    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:CreateGrant",
    ]
  }
}

resource "aws_iam_policy" "efs_kms_backup_restore" {
  name        = "${var.cluster_name}-${var.backup_restore_policy_name}"
  description = "Policy for EFS backup and restore with KMS encryption"
  path        = var.iam_path

  policy = data.aws_iam_policy_document.backup_efs_policy.json
}

data "aws_iam_policy_document" "backup_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "efs_backup_restore_role" {
  name                 = "${var.cluster_name}-${var.iam_backup_restore_role_name}"
  path                 = var.iam_path
  permissions_boundary = var.permissions_boundary
  assume_role_policy   = data.aws_iam_policy_document.backup_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "efs_backup_restore_attach" {
  policy_arn = aws_iam_policy.efs_kms_backup_restore.arn
  role       = aws_iam_role.efs_backup_restore_role.name
}
