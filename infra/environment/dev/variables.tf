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

#------------------------------
# ECS
#------------------------------
variable "retention_in_days" {
  description = "ログの保存期間(デフォルトは無期限)"
  type        = number
}

#------------------------------
# ECS / Clustr
#------------------------------
variable "container_insights" { type = string }


#------------------------------
# task definition
#------------------------------
# logConfiguration(ログの出力先)は、mainにハードコード
# familyは、var.projectと併せるため objectの外に定義

variable "task_conf" {
  description = "タスク定義"
  type = object({

    # task
    cpu                      = number       # (H/W) CPU
    memory                   = number       # (H/W) メモリ
    network_mode             = string       # (NW) モード (Fargate -> awsvpc)
    requires_compatibilities = list(string) # (OP) 起動モード (Fargate -> FARGATE)

    # runtime_platform
    operating_system_family = string # OS (Fargate -> Linux)
    cpu_architecture        = string # (H/W) CPUアーキテクチャ (AppleシリコンMAC -> ARM64)

    # container_definitions
    name      = string # コンテナ名
    essential = bool   # (OP) 停止フラグ(Trueのコンテナが止まるとタスク全体が停止)

    # port_mappings
    port     = number # (NW) ポート (Fargate -> hostと揃える)
    protocol = string # (NW) プロトコル (Fargate -> tcp)
  })
}

variable "db_conf" {
  description = "データベースの接続情報"
  type = object({
    host     = string
    database = string
    username = string
    password = string
    ssl      = string
  })
  sensitive = true # planに非出力(stateには記述される点に留意)
}

#------------------------------
# ECS / Service
#------------------------------
variable "service_conf" {
  description = "サービス設定"
  type = object({
    desired_count    = number # 稼働させるコンテナの数
    launch_type      = string # マシンの起動タイプ
    assign_public_ip = bool   # PublicIPが必要か
  })
}