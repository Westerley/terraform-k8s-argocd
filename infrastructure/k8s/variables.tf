variable "kube_config_path" {
  description = "Configurações do cluster k3d kubernetes"
  type        = string
  default     = "~/.kube/config"
}

variable "argocd_admin_secret" {
  description = "Senha de acesso para o ArgoCD"
  type        = string
}

variable "argocd_admin_secret_time" {
  description = "Horário de criação da senha de acesso"
  type        = string
}

variable "ssh_repo" {
  description = "Chave Privada do repositório"
  type        = string
}

variable "repo_url" {
  description = "URL de acesso para o respositório"
  type        = string
}

variable "repo_branch" {
  description = "Branch principal do repositório"
  type        = string
  default     = "main"
}

variable "postgres_user" {
  description = "Usuário do banco postgress"
  type        = string
}

variable "postgres_password" {
  description = "Senha do banco postgres"
  type        = string
}