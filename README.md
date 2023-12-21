# batcave-tf-efs

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_admin"></a> [iam\_assumable\_role\_admin](#module\_iam\_assumable\_role\_admin) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_selection.daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_policy.efs_backup_vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |
| [aws_efs_backup_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_backup_policy) | resource |
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_iam_policy.batcave_efscsidriver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.efs_kms_backup_restore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.efs_backup_restore_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.efs_backup_restore_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.service_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.efs_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [helm_release.aws-efs-csi-driver](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [time_sleep.iam_delay](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.backup_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.backup_efs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.batcave_efscsidriver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.service_link](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vault_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Account ID for the current AWS account | `any` | n/a | yes |
| <a name="input_backup_completion_window_minutes"></a> [backup\_completion\_window\_minutes](#input\_backup\_completion\_window\_minutes) | Amount of time (in minutes) a backup job can run before it is automatically canceled | `number` | `180` | no |
| <a name="input_backup_restore_policy_name"></a> [backup\_restore\_policy\_name](#input\_backup\_restore\_policy\_name) | n/a | `string` | `"EFSBackupRestore"` | no |
| <a name="input_backup_start_window_minutes"></a> [backup\_start\_window\_minutes](#input\_backup\_start\_window\_minutes) | Amount if time (in minutes) before starting a backup job | `number` | `60` | no |
| <a name="input_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#input\_cluster\_certificate\_authority\_data) | CA certificate data for EKS cluster | `any` | n/a | yes |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | Endpoint for EKS cluster | `any` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of EKS cluster | `any` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for EKS cluster | `any` | n/a | yes |
| <a name="input_daily_backup_days_to_retain"></a> [daily\_backup\_days\_to\_retain](#input\_daily\_backup\_days\_to\_retain) | Days to retain the backup vault backups | `string` | `"30"` | no |
| <a name="input_daily_backup_force_destroy"></a> [daily\_backup\_force\_destroy](#input\_daily\_backup\_force\_destroy) | Force destroy the backup vault | `bool` | `false` | no |
| <a name="input_daily_backup_tag_key"></a> [daily\_backup\_tag\_key](#input\_daily\_backup\_tag\_key) | Tag Key for backing up resources daily | `string` | `""` | no |
| <a name="input_daily_backup_tag_value"></a> [daily\_backup\_tag\_value](#input\_daily\_backup\_tag\_value) | Tag Value for backing up resources daily | `string` | `""` | no |
| <a name="input_directory_perms"></a> [directory\_perms](#input\_directory\_perms) | Storage Class directory permissions | `string` | `"700"` | no |
| <a name="input_efsid"></a> [efsid](#input\_efsid) | EFS filesystem ID | `string` | `""` | no |
| <a name="input_gid_range_end"></a> [gid\_range\_end](#input\_gid\_range\_end) | Storage Class directory permissions | `string` | `"2000"` | no |
| <a name="input_gid_range_start"></a> [gid\_range\_start](#input\_gid\_range\_start) | Storage Class directory permissions | `string` | `"100"` | no |
| <a name="input_helm_name"></a> [helm\_name](#input\_helm\_name) | Name for Helm release | `string` | `"aws-efs-csi-driver"` | no |
| <a name="input_helm_namespace"></a> [helm\_namespace](#input\_helm\_namespace) | Namespace for Helm chart | `string` | `"kube-system"` | no |
| <a name="input_iam_backup_restore_role_name"></a> [iam\_backup\_restore\_role\_name](#input\_iam\_backup\_restore\_role\_name) | n/a | `string` | `"EFSBackupRestoreRole"` | no |
| <a name="input_iam_path"></a> [iam\_path](#input\_iam\_path) | Path for IAM roles | `string` | `"/delegatedadmin/developer/"` | no |
| <a name="input_imagerepo"></a> [imagerepo](#input\_imagerepo) | ECR repository for container images | `string` | `"602401143452.dkr.ecr.us-west-2.amazonaws.com/eks/aws-efs-csi-driver"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ID for secrets encryption | `string` | `""` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | Permissions boundary for IAM roles | `string` | `""` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | n/a | `list(any)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional; Map of key-value tags to apply to applicable resources | `map(any)` | `{}` | no |
| <a name="input_tags_backup_plan"></a> [tags\_backup\_plan](#input\_tags\_backup\_plan) | Optional; Map of key-value tags to apply to all backup plans | `map(any)` | `{}` | no |
| <a name="input_tags_backup_vault"></a> [tags\_backup\_vault](#input\_tags\_backup\_vault) | Optional; Map of key-value tags to apply to all backup vaults | `map(any)` | `{}` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | ## Helm variables | `list(any)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for EKS cluster | `any` | n/a | yes |
| <a name="input_worker_security_group_id"></a> [worker\_security\_group\_id](#input\_worker\_security\_group\_id) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_oidc_iam_role_arn"></a> [oidc\_iam\_role\_arn](#output\_oidc\_iam\_role\_arn) | n/a |
<!-- END_TF_DOCS -->
