locals {
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "aws-efs-csi-driver"
}

resource "aws_iam_policy" "batcave_efscsidriver" {
  name = "efscsidriver-policy-${var.cluster_name}"
  path = var.iam_path
  policy = <<-EOD
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems",
          "sts:AssumeRoleWithWebIdentity"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "elasticfilesystem:CreateAccessPoint"
        ],
        "Resource": "*",
        "Condition": {
          "StringLike": {
            "aws:RequestTag/efs.csi.aws.com/cluster": "true",
            "aws:RequestTag/cluster-name": "${var.cluster_name}"
          }
        }
      },
      {
        "Effect": "Allow",
        "Action": "elasticfilesystem:DeleteAccessPoint",
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "aws:ResourceTag/efs.csi.aws.com/cluster": "true",
            "aws:ResourceTag/cluster-name": "${var.cluster_name}"
          }
        }
      }
    ]
  }
  EOD
}


module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  create_role                   = true
  role_name                     = "${var.cluster_name}-cluster-efscsidriver"
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.batcave_efscsidriver.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_service_account_namespace}:efs-csi-controller-sa","system:serviceaccount:${local.k8s_service_account_namespace}:efs-csi-node-sa"]
  role_path                     = var.iam_path
  role_permissions_boundary_arn = var.permissions_boundary
}
