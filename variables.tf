variable "cluster_name" {
  description = "Name of EKS cluster"
}

variable "account_id" {
  description = "Account ID for the current AWS account"
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

variable "iam_backup_restore_role_name" {
  type    = string
  default = "EFSBackupRestoreRole"
}

variable "backup_restore_policy_name" {
  type    = string
  default = "EFSBackupRestore"
}

### Helm variables
variable "tolerations" {
  type    = list(any)
  default = []
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
}

variable "private_subnet_ids" {
  type    = list(any)
  default = []
}

variable "worker_security_group_id" {
  type = string
}

variable "backup_start_window_minutes" {
  type        = number
  description = "Amount if time (in minutes) before starting a backup job"
  default     = 60
}
variable "backup_completion_window_minutes" {
  type        = number
  description = "Amount of time (in minutes) a backup job can run before it is automatically canceled"
  default     = 180
}


# daily backup settings
variable "daily_backup_tag_key" {
  type        = string
  description = "Tag Key for backing up resources daily"
  default     = ""
}

variable "daily_backup_tag_value" {
  type        = string
  description = "Tag Value for backing up resources daily"
  default     = ""
}

variable "daily_backup_days_to_retain" {
  type        = string
  description = "Days to retain the backup vault backups"
  default     = "30"
}

# tagging
variable "tags" {
  type        = map(any)
  description = "Optional; Map of key-value tags to apply to applicable resources"
  default     = {}
}
variable "tags_backup_vault" {
  type        = map(any)
  description = "Optional; Map of key-value tags to apply to all backup vaults"
  default     = {}
}
variable "tags_backup_plan" {
  type        = map(any)
  description = "Optional; Map of key-value tags to apply to all backup plans"
  default     = {}
}

# Creating variables for storageclass
variable "directory_perms" {
  type        = string
  description = "Storage Class directory permissions"
  default     = "700"
}

variable "gid_range_start" {
  type        = string
  description = "Storage Class directory permissions"
  default     = "100"
}

variable "gid_range_end" {
  type        = string
  description = "Storage Class directory permissions"
  default     = "2000"
}

variable "daily_backup_force_destroy" {
  type        = bool
  description = "Force destroy the backup vault"
  default     = false
}
