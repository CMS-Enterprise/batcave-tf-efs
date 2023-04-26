variable "cluster_name" {}
variable "cluster_endpoint" {}
variable "cluster_certificate_authority_data" {}



variable "iam_path" {
  default = "/delegatedadmin/developer/"
}

variable "permissions_boundary" {
  default = ""
  ## check this value in common.hcl file for dev
  #arn:aws:iam::373346310182:policy/cms-cloud-admin/developer-boundary-policy
}

variable "toleration_key" {
  type        = string
  description = "toleration key"
}

variable "toleration_value" {
  type        = string
  description = "toleration value"
}

variable "toleration_operator" {
  type        = string
  description = "toleration operator"
}

variable "toleration_effect" {
  type        = string
  description = "toleration effect"
}

### Helm variables
variable "helm_namespace" {
  default = "kube-system"
}

## Image repo
variable "imagerepo" {
  default = "602401143452.dkr.ecr.us-west-2.amazonaws.com/eks/aws-efs-csi-driver"
}

variable "efsid" {
  default = ""
}

variable "helm_name" {
  default = "aws-efs-csi-driver"
}

variable "cluster_oidc_issuer_url" {}

variable "kms_key_id" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "private_subnet_ids" {
  type    = list(any)
  default = []
}