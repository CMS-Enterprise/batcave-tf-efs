data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Assume Role Poliy for AWS Backup Service
data "aws_iam_policy_document" "service_link" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

locals {
  daily_backup = var.daily_backup_tag_key == "" ? {} : {(var.daily_backup_tag_key) = coalesce(var.daily_backup_tag_value, var.cluster_name)}
}

resource "aws_iam_role" "service_role" {
  name                 = "${var.cluster_name}-backup-service-role"
  path                 = var.iam_path
  permissions_boundary = var.permissions_boundary
  assume_role_policy   = data.aws_iam_policy_document.service_link.json
}
resource "aws_iam_role_policy_attachment" "service_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.service_role.name
}

resource "aws_backup_vault" "daily" {
  name    = "${var.cluster_name}_daily_backup"
  tags    = merge(var.tags, var.tags_backup_vault, local.daily_backup)
}

resource "aws_backup_plan" "daily" {
  name = "${var.cluster_name}_daily_backup"
  tags = merge(var.tags, var.tags_backup_plan, local.daily_backup)

  rule {
    rule_name         = "${var.cluster_name}_daily_backup"
    target_vault_name = aws_backup_vault.daily.name
    schedule          = "cron(0 8 ? * * *)"
    start_window      = var.backup_start_window_minutes
    completion_window = var.backup_completion_window_minutes

    lifecycle {
      delete_after = 30
    }
  }
}

resource "aws_backup_selection" "daily" {
  iam_role_arn = aws_iam_role.service_role.arn
  name         = "${var.cluster_name}_daily_backup"
  plan_id      = aws_backup_plan.daily.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = var.daily_backup_tag_key
    value = var.daily_backup_tag_value
  }
}
