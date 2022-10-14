
resource "helm_release" "aws-efs-csi-driver" {
  namespace = var.helm_namespace

  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"

  set {
    name  = "image.repository"
    value = var.imagerepo
  }
  set {
     name = "controller.serviceAccount.name"
     value = "efs-csi-controller-sa"
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
     name = "controller.tags.cluster-name"
     value = var.cluster_name
  }
  }

 

