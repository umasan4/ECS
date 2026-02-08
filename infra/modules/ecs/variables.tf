#--------------------------------
# mysql
#--------------------------------
variable "mysql_host" { type = string }
variable "mysql_database" { type = string }
variable "mysql_username" { type = string }
variable "mysql_ssl" { type = string }
variable "mysql_password" {
  type      = string
  sensitive = true # planなどで非出力
}

#------------------------------
# ECS
#------------------------------
### policy and role / cloudwatch log ###
variable "policy_name" { type = string }
variable "role_name" { type = string }
variable "log_name" { type = string }

variable "retention_in_days" {
  description = "ログの保存期間(デフォルトは無期限)"
  type        = number
}

### cluster ###
variable "cluster_name" { type = string }
variable "container_insights" { type = string }

### task definition ###
variable "family" {
  description = "タスク定義の名前"
  type        = string
}
variable "network_mode" {
  description = "Fargate なら awsvpcを指定"
  type        = string
}
variable "requires_compatibilities" {
  description = "起動タイプ"
  type        = list(string)
}

variable "cpu" { type = number }
variable "memory" { type = number }

### container ###
variable "container_name" { type = string }
variable "image_uri" { type = string }
variable "container_port" { type = number }

### service ###
variable "service_name" { type = string }
variable "desired_count" {
  description = "【重要】常に稼働させるコンテナの数"
  type        = number
}
variable "launch_type" {
  description = "マシンの起動タイプ"
  type        = string
}
variable "assign_public_ip" {
  description = "ブリックIPが必要か否か、Public Subnet なら true"
  type        = bool
}
variable "subnets" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}
variable "target_group_arn" {
  type = string
}