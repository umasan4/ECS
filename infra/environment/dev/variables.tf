#--------------------------------
# local vars
#--------------------------------
locals { # vpc_endpointで使用
  type_interface = "Interface"
  type_gateway   = "Gateway"
  service_prefix = "com.amazonaws"
}

#--------------------------------
# data
#--------------------------------
# 現在のASWリージョン情報を取得する
data "aws_region" "current" {}

#--------------------------------
# tags
#--------------------------------
variable "project" {
  type    = string
  default = "ecs-practice"
}

variable "environment" {
  type    = string
  default = "dev"
}

#--------------------------------
# vpc
#--------------------------------
variable "cidr_block" { type = string }

#--------------------------------
# subnets
#--------------------------------
### public ###
variable "public_subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
}

### private ###
variable "private_subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
}

#--------------------------------
# sg
#--------------------------------
### forntend_sg ###
variable "frontend_sg" {
  type = map(object({
    type                     = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
  }))
}

### webapp_sg ###
variable "webapp_sg" {
  type = map(object({
    type                     = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
  }))
}

### database_sg ###
variable "database_sg" {
  type = map(object({
    type                     = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
  }))
}

### vpc_endpoint_sg ###
variable "vpc_endpoint_sg" {
  type = map(object({
    type                     = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
  }))
}

#--------------------------------
# vpce
#--------------------------------
# (if型 -> sg & subnet) / (gw型 -> rt)
variable "s3_vpce" {
  default = {}
  type = map(object({
    vpc_endpoint_type   = string
    service_name        = optional(string)
    policy              = optional(string)
    security_group_ids  = optional(list(string))
    route_table_ids     = optional(list(string))
    subnet_ids          = optional(list(string))
    private_dns_enabled = optional(bool)
  }))
}

variable "ecr_dkr_vpce" {
  default = {}
  type = map(object({
    vpc_endpoint_type   = string
    service_name        = optional(string)
    policy              = optional(string)
    security_group_ids  = optional(list(string))
    route_table_ids     = optional(list(string))
    subnet_ids          = optional(list(string))
    private_dns_enabled = optional(bool)
  }))
}

variable "ecr_api" {
  default = {}
  type = map(object({
    vpc_endpoint_type   = string
    service_name        = optional(string)
    policy              = optional(string)
    security_group_ids  = optional(list(string))
    route_table_ids     = optional(list(string))
    subnet_ids          = optional(list(string))
    private_dns_enabled = optional(bool)
  }))
}

variable "cloudwatch" {
  default = {}
  type = map(object({
    vpc_endpoint_type   = string
    service_name        = optional(string)
    policy              = optional(string)
    security_group_ids  = optional(list(string))
    route_table_ids     = optional(list(string))
    subnet_ids          = optional(list(string))
    private_dns_enabled = optional(bool)
  }))
}

variable "ssm" {
  default = {}
  type = map(object({
    vpc_endpoint_type   = string
    service_name        = optional(string)
    policy              = optional(string)
    security_group_ids  = optional(list(string))
    route_table_ids     = optional(list(string))
    subnet_ids          = optional(list(string))
    private_dns_enabled = optional(bool)
  }))
}

variable "secretmanager" {
  default = {}
  type = map(object({
    vpc_endpoint_type   = string
    service_name        = optional(string)
    policy              = optional(string)
    security_group_ids  = optional(list(string))
    route_table_ids     = optional(list(string))
    subnet_ids          = optional(list(string))
    private_dns_enabled = optional(bool)
  }))
}

variable "ssmmessages" {
  default = {}
  type = map(object({
    vpc_endpoint_type   = string
    service_name        = optional(string)
    policy              = optional(string)
    security_group_ids  = optional(list(string))
    route_table_ids     = optional(list(string))
    subnet_ids          = optional(list(string))
    private_dns_enabled = optional(bool)
  }))
}

#--------------------------------
# ecr
#--------------------------------
variable "image_tag_mutability" { type = string }
variable "scan_on_push" { type = bool }
variable "force_delete" {
  type    = bool
  default = false
}

#--------------------------------
# elb
#--------------------------------
variable "internal" { type = bool }
variable "load_balancer_type" { type = string }
variable "enable_deletion_protection" { type = bool }
variable "enable_http2" { type = bool }

#--------------------------------
# target_group
#--------------------------------
### target_group ###
variable "port" { type = number }
variable "protocol" { type = string }
variable "target_type" { type = string }

### health_check ###
variable "path" { type = string }
variable "interval" { type = number }
variable "timeout" { type = number }
variable "healthy_threshold" { type = number }
variable "unhealthy_threshold" { type = number }
variable "matcher" { type = string }
variable "hc_port" { type = string }
variable "hc_protocol" { type = string }

#--------------------------------
# listener
#--------------------------------
### listener ###
variable "listener_port" { type = number }
variable "listener_protocol" { type = string }

### default_action ###
variable "listener_type" { type = string }

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
# variable "policy_name" { type = string }
# variable "role_name" { type = string }
# variable "log_name" { type = string }

variable "retention_in_days" {
  description = "ログの保存期間(デフォルトは無期限)"
  type        = number
}

### cluster ###
# variable "cluster_name" { type = string }
variable "container_insights" { type = string }

### task definition ###
# variable "family" {
#   description = "タスク定義の名前"
#   type        = string
# }
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
#variable "container_name" { type = string }
# variable "image_uri" { type = string }
variable "container_port" { type = number }

### service ###
# variable "service_name" { type = string }
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