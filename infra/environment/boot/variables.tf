#--------------------------------
# tags
#--------------------------------
variable "project" {
  type    = string
  default = "ecs-practice"
}

variable "environment" {
  type    = string
  default = "boot"
}

#-------------------------------
# remote backend
#-------------------------------
# リモートバックエンド用のバケットに付ける名前
# 環境名をリストに追加することで複数環境分のバケットを作成可能
variable "rb_environment" {
  type    = list(string)
  default = ["boot", "dev"]
}

variable "bucket_suffix" {
  type    = string
  default = "remote-backend"
}

#-------------------------------
# oidc
#-------------------------------
variable "name" {
  type    = string
  default = "github-actions-oidc-role"
}

variable "github_repo" {
  type    = string
  default = "yuma-inoue4/ECS"
}

variable "role_name" {
  type    = string
  default = "github-actions-oidc-role"
}

variable "policy_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/AdministratorAccess"
}