# Generate argocd password
# htpasswd -nbBC 10 "" <your-secret> | tr -d ':\n' | sed 's/$2y/$2a/' && date -u +'%Y-%m-%dT%H:%M:%SZ'
argocd_admin_secret      = ""
argocd_admin_secret_time = "2022-08-15T17:16:39Z"
ssh_repo                 = <<EOF
-----BEGIN OPENSSH PRIVATE KEY-----
-----END OPENSSH PRIVATE KEY-----
EOF
postgres_user            = ""
postgres_password        = ""
repo_url                 = "git@github.com:Westerley/terraform-k8s-argocd.git"