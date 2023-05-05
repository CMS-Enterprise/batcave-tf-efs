
resource "helm_release" "aws-efs-csi-driver" {
  namespace  = var.helm_namespace
  name       = var.helm_name
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  version    = "2.2.9"
  set {
    name  = "image.repository"
    value = var.imagerepo
  }
  set {
    name  = "controller.serviceAccount.name"
    value = local.controller_service_account_name
  }
  set {
    name  = "node.serviceAccount.name"
    value = local.node_service_account_name
  }
  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_admin.iam_role_arn
  }
  set {
    name  = "node.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_admin.iam_role_arn
  }
  set {
    name  = "controller.tags.cluster-name"
    value = var.cluster_name
  }
  set {
    name  = "storageClasses[0].name"
    value = "efs-sc"
  }
  set {
    name  = "storageClasses[0].mountOptions"
    value = "{tls}"
  }
  set {
    name  = "storageClasses[0].parameters.provisioningMode"
    value = "efs-ap"
  }
  set {
    name  = "storageClasses[0].parameters.fileSystemId"
    value = aws_efs_file_system.efs.id
  }
  set {
    name  = "storageClasses[0].parameters.basePath"
    value = "/dynamic_provisioning"
  }
  set {
    name  = "storageClasses[0].parameters.directoryPerms"
    value = "700"
    type  = "string"
  }
  set {
    name  = "storageClasses[0].parameters.gidRangeStart"
    value = "1000"
    type  = "string"
  }
  set {
    name  = "storageClasses[0].parameters.gidRangeEnd"
    value = "2000"
    type  = "string"
  }
  set {
    name  = "storageClasses[0].reclaimPolicy"
    value = "Retain"
  }
  set {
    name  = "storageClasses[0].volumeBindingMode"
    value = "Immediate"
  }
  dynamic "set" {
    for_each = var.tolerations
    content {
      name  = "controller.tolerations[${set.key}].key"
      value = set.value.key
    }
  }
  dynamic "set" {
    for_each = var.tolerations
    content {
      name  = "controller.tolerations[${set.key}].value"
      value = try(set.value.value, "")
    }
  }
  dynamic "set" {
    for_each = var.tolerations
    content {
      name  = "controller.tolerations[${set.key}].operator"
      value = set.value.operator
    }
  }
  dynamic "set" {
    for_each = var.tolerations
    content {
      name  = "controller.tolerations[${set.key}].effect"
      value = try(set.value.effect, "NoSchedule")
    }
  }
}
