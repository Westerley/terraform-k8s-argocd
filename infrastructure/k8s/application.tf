resource "kubectl_manifest" "app_namespace" {
  yaml_body = templatefile(
    "../manifests/namespace.yaml",
    {
      NAME = "vote"
    }
  )
}

resource "kubectl_manifest" "applications_resultado" {
  depends_on = [
    helm_release.argocd,
    kubectl_manifest.app_namespace
  ]
  yaml_body = templatefile(
    "../manifests/template.yaml",
    {
      NAME          = "resultado"
      REPO_URL      = var.repo_url,
      REPO_BRANCH   = var.repo_branch,
      REPO_PATH     = "applications/app_resultado"
      APP_NAMESPACE = kubectl_manifest.app_namespace.name,
    }
  )
}

resource "kubectl_manifest" "applications_votacao" {
  depends_on = [
    helm_release.argocd,
    kubectl_manifest.app_namespace
  ]
  yaml_body = templatefile(
    "../manifests/template.yaml",
    {
      NAME          = "votacao"
      REPO_URL      = var.repo_url,
      REPO_BRANCH   = var.repo_branch,
      REPO_PATH     = "applications/app_votacao"
      APP_NAMESPACE = kubectl_manifest.app_namespace.name,
    }
  )
}

resource "kubectl_manifest" "applications_worker" {
  depends_on = [
    helm_release.argocd,
    kubectl_manifest.app_namespace
  ]
  yaml_body = templatefile(
    "../manifests/template.yaml",
    {
      NAME          = "worker"
      REPO_URL      = var.repo_url,
      REPO_BRANCH   = var.repo_branch,
      REPO_PATH     = "applications/app_worker"
      APP_NAMESPACE = kubectl_manifest.app_namespace.name,
    }
  )
}

data "kubectl_path_documents" "app_secrets" {
  pattern = "../manifests/app-secrets.yaml"
  vars = {
    POSTGRES_USER     = base64encode("${trimspace(var.postgres_user)}"),
    POSTGRES_PASSWORD = base64encode("${trimspace(var.postgres_password)}")
  }
}

resource "kubectl_manifest" "app_secrets" {
  depends_on = [
    helm_release.argocd,
    kubectl_manifest.app_namespace
  ]
  count              = length(data.kubectl_path_documents.app_secrets.documents)
  yaml_body          = element(data.kubectl_path_documents.app_secrets.documents, count.index)
  override_namespace = kubectl_manifest.app_namespace.name
}

resource "kubectl_manifest" "database" {
  depends_on = [
    helm_release.argocd,
    kubectl_manifest.app_namespace
  ]
  yaml_body = templatefile(
    "../manifests/template.yaml",
    {
      NAME          = "database"
      REPO_URL      = var.repo_url,
      REPO_BRANCH   = var.repo_branch,
      REPO_PATH     = "applications/database"
      APP_NAMESPACE = kubectl_manifest.app_namespace.name
    }
  )
}

resource "kubectl_manifest" "redis" {
  depends_on = [
    helm_release.argocd,
    kubectl_manifest.app_namespace
  ]
  yaml_body = templatefile(
    "../manifests/template.yaml",
    {
      NAME          = "redis"
      REPO_URL      = var.repo_url,
      REPO_BRANCH   = var.repo_branch,
      REPO_PATH     = "applications/redis"
      APP_NAMESPACE = kubectl_manifest.app_namespace.name
    }
  )
}