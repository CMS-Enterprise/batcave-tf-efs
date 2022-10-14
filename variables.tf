variable "cluster_name" {}
variable "cluster_endpoint" {}
variable "cluster_certificate_authority_data" {}

### Karpenter IAM variables
variable "worker_iam_role_name" {
  default = ""
}

variable "iam_path" {
  default = "/delegatedadmin/developer/"
}

variable "permissions_boundary" {
  default = "arn:aws:iam::373346310182:policy/cms-cloud-admin/developer-boundary-policy"
}


### Helm variables
variable "helm_namespace" {
  default = "kube-system"
}

## Image repo 
variable "imagerepo" {
  default = "602401143452.dkr.ecr.us-west-2.amazonaws.com/eks/aws-efs-csi-driver"
}

variable "helm_name" {
  default = "aws-efs-csi-driver"
}

variable "self_managed_node_groups" {
  type = map(any)
}

# ENIConfig Variables
variable "vpc_eni_subnets" {
  type = map(any)
}

variable "worker_security_group_id" {
  type = string
}



variable "cluster_oidc_issuer_url" {}




# Pod limit values
variable "cpu_limits" {
  default = "50m"
}

variable "cpu_requests" {
  default = "10m"
}

variable "memory_limits" {
  default = "512Mi"
}

variable "memory_requests" {
  default = "50Mi"
}
