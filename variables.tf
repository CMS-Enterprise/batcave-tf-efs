variable "cluster_name" {
  description = "Name of EKS cluster"
}

variable "cluster_endpoint" {
  description = "Endpoint for EKS cluster"
}

variable "cluster_certificate_authority_data" {
  description = "CA certificate data for EKS cluster"
}

variable "iam_path" {
  description = "Path for IAM roles"
  default     = "/delegatedadmin/developer/"
}

variable "permissions_boundary" {
  description = "Permissions boundary for IAM roles"
  default     = ""
}

variable "toleration_key" {
  description = "Key for pod tolerations"
  default     = ""
}

variable "toleration_value" {
  description = "Value for pod tolerations"
  default     = ""
}

variable "toleration_operator" {
  description = "Operator for pod tolerations"
  default     = ""
}

variable "toleration_effect" {
  description = "Effect for pod tolerations"
  default     = ""
}

variable "helm_namespace" {
  description = "Namespace for Helm chart"
  default     = "kube-system"
}

variable "imagerepo" {
  description = "ECR repository for container images"
  default     = "602401143452.dkr.ecr.us-west-2.amazonaws.com/eks/aws-efs-csi-driver"
}

variable "efsid" {
  description = "EFS filesystem ID"
  default     = ""
}

variable "helm_name" {
  description = "Name for Helm release"
  default     = "aws-efs-csi-driver"
}

variable "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for EKS cluster"
}

variable "kms_key_id" {
  description = "KMS key ID for secrets encryption"
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID for EKS cluster"
  default     = ""
}

variable "private_subnet_ids" {
  description = "IDs of private subnets in VPC"
  type        = list(any)
  default     = []
}
