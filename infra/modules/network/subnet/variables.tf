#--------------------------------
# tags
#--------------------------------
variable "name" { type = string }

#--------------------------------
# network
#--------------------------------
variable "vpc_id" { type = string }
variable "route_table_id" { type = string }

variable "subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
}