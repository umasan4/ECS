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