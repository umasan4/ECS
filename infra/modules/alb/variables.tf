#--------------------------------
# elb
#--------------------------------
variable "lb_name" { type = string }
variable "internal" { type = bool }
variable "load_balancer_type" { type = string }
variable "security_groups" { type = list(string) }
variable "subnets" { type = list(string) }
variable "enable_deletion_protection" { type = bool }
variable "enable_http2" { type = bool }

#--------------------------------
# target_group
#--------------------------------
### target_group ###
variable "tg_name" { type = string }
variable "vpc_id" { type = string }
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
variable "listener_name" { type = string }
variable "listener_port" { type = number }
variable "listener_protocol" { type = string }

### default_action ###
variable "listener_type" { type = string }