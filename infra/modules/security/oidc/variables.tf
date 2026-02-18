variable "github_repo" {
  description = "GitHub repository name (format: User/Repo)"
  type        = string
  # 例:"umasan4/Ansible"
}

variable "role_name" {
  # 環境ごとに一意の名前にする
  description = "IAM Role name for GitHub Actions"
  type        = string
  default     = "github-actions-oidc-role"
}

variable "policy_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/AdministratorAccess"
}