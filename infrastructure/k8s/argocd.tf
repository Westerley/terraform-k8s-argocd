# ArgoCD Namespace
resource "kubectl_manifest" "argocd_namespace" {
  yaml_body = templatefile(
    "../manifests/namespace.yaml",
    {
      NAME = "argocd"
    }
  )
}

# Add ArgoCD using Helm
resource "helm_release" "argocd" {
  depends_on = [kubectl_manifest.argocd_namespace]
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubectl_manifest.argocd_namespace.name
  wait       = false
  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.argocd_admin_secret
  }
  set {
    name  = "configs.secret.argocdServerAdminPasswordMtime"
    value = var.argocd_admin_secret_time
  }
}

data "kubectl_path_documents" "argocd-repositories" {
  pattern = "../manifests/argocd-repositories.yaml"
  vars = {
    REPO_URL = var.repo_url,
    SSH_REPO = indent(4, var.ssh_repo)
  }
}

resource "kubectl_manifest" "argocd-repositories" {
  depends_on = [
    helm_release.argocd
  ]
  count              = length(data.kubectl_path_documents.argocd-repositories.documents)
  yaml_body          = element(data.kubectl_path_documents.argocd-repositories.documents, count.index)
  override_namespace = kubectl_manifest.argocd_namespace.name
  sensitive_fields   = ["stringData.sshPrivateKey"]
}