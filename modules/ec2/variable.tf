variable "vpc_id" {
  default = null
  description = "a deployed vpc id"
}

variable "subnet_ids" {
  type = list(string)
  default = null
  description = "a deployed subnet ids, it must be attached vpc_id"
}

variable "security_group_ids" {
  type = list(string)
  default = null
  description = "attached security_group at querypie proxy"
}