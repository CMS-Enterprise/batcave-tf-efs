output "oidc_iam_role_arn" {
  value = module.iam_assumable_role_admin.iam_role_arn
}

output "backup_iam_role_arn" {
  description = "ARN of IAM role"
  value       = aws_iam_role.efs_backup_restore_role.arn
}
