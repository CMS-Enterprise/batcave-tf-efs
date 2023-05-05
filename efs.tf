resource "aws_security_group" "efs" {
  description = "${var.cluster_name} EFS"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "efs_ingress" {
  security_group_id        = aws_security_group.efs.id
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = var.worker_security_group_id
}

data "aws_kms_key" "efs" {
  key_id = var.kms_key_id
}

resource "aws_efs_file_system" "efs" {
  creation_token = var.cluster_name

  encrypted  = true
  kms_key_id = data.aws_kms_key.efs.arn

  tags = {
    Name = "${var.cluster_name}"
  }
  lifecycle_policy {
    transition_to_ia = "AFTER_60_DAYS"
  }
}

resource "aws_efs_mount_target" "efs" {
  for_each        = toset(var.private_subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = each.key
  security_groups = [aws_security_group.efs.id]
}
resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.efs.id

  backup_policy {
    status = "ENABLED"
  }
}