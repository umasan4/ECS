# 必要
variable "vpc_id" { type = string }
variable "name" { type = string }

variable "routes" {
  description = "デフォルトは空"
  type = map(object({
    cidr_block           = string
    network_interface_id = optional(string)
    gateway_id           = optional(string)
  }))
  default = {}
}