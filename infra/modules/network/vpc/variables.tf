variable "cidr_block" {
  type = string
}

variable "instance_tenancy" {
  type        = string
  description = "EC2作成時に物理サーバを占有するか否か"
  default     = "default"
}

variable "environment" {
  type = string
}

variable "project" {
  type = string
}