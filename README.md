# batcave-tf-efs
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_admin"></a> [iam\_assumable\_role\_admin](#module\_iam\_assumable\_role\_admin) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_efs_backup_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_backup_policy) | resource |
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_iam_policy.batcave_efscsidriver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_security_group.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [helm_release.aws-efs-csi-driver](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.batcave_efscsidriver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#input\_cluster\_certificate\_authority\_data) | n/a | `any` | n/a | yes |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | n/a | `any` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | n/a | `any` | n/a | yes |
| <a name="input_efsid"></a> [efsid](#input\_efsid) | n/a | `string` | `""` | no |
| <a name="input_helm_name"></a> [helm\_name](#input\_helm\_name) | n/a | `string` | `"aws-efs-csi-driver"` | no |
| <a name="input_helm_namespace"></a> [helm\_namespace](#input\_helm\_namespace) | ## Helm variables | `string` | `"kube-system"` | no |
| <a name="input_iam_path"></a> [iam\_path](#input\_iam\_path) | n/a | `string` | `"/delegatedadmin/developer/"` | no |
| <a name="input_imagerepo"></a> [imagerepo](#input\_imagerepo) | # Image repo | `string` | `"602401143452.dkr.ecr.us-west-2.amazonaws.com/eks/aws-efs-csi-driver"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | n/a | `string` | `""` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | n/a | `string` | `""` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | n/a | `list(any)` | `[]` | no |
| <a name="input_toleration_effect"></a> [toleration\_effect](#input\_toleration\_effect) | toleration effect | `string` | `""` | no |
| <a name="input_toleration_key"></a> [toleration\_key](#input\_toleration\_key) | toleration key | `string` | `""` | no |
| <a name="input_toleration_operator"></a> [toleration\_operator](#input\_toleration\_operator) | toleration operator | `string` | `""` | no |
| <a name="input_toleration_value"></a> [toleration\_value](#input\_toleration\_value) | toleration value | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_oidc_iam_role_arn"></a> [oidc\_iam\_role\_arn](#output\_oidc\_iam\_role\_arn) | n/a |
<!-- END_TF_DOCS -->