locals {
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "aws-efs-csi-driver"
}

data "aws_iam_policy_document" "batcave_efscsidriver" {
  statement {
    actions = [
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems",
    ]

    resources = [
      "arn:aws:elasticfilesystem:*:190002946201:file-system/${aws_efs_file_system.efs.id}",
      "arn:aws:elasticfilesystem:*:190002946201:access-point/*"
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
