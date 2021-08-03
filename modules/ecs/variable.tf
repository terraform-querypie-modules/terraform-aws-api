variable "image" {
  type        = string
  default     = "dockerpie.querypie.com/chequer.io/querypie-app:latest"
  description = "querypie image tag"
}

variable "application_credentials" {
  type = string
  default = null
  description = "querypie application session"
  validation {
    condition = var.application_credentials != null
    error_message = "Make sure your input value, the conditions satisfied."
  }
}

variable "jdbc_driver_class_name" {
  type = string
  default = "com.mysql.cj.jdbc.Driver"
  description = "querypie database driver which suppport MySQL, MariaDB"
}

variable "log_group_name" {
  type = string
  default = null
  description = "logging group name"
}

variable "vpc_id" {
  default     = null
  description = "a deployed vpc id"
}

variable "subnet_ids" {
  type        = list(string)
  default     = null
  description = "a deployed subnet ids, it must be attached vpc_id"
}

variable "security_group_ids" {
  type        = list(string)
  default     = null
  description = "attached security_group at querypie proxy"
}

variable "task_execute_role_arn" {
  type = string
  default = null
  validation {
    condition     = var.task_execute_role_arn != null
    error_message = "Make sure your input value, the conditions satisfied."
  }
}

variable "image_pull_secret_arn" {
  type = string
  default =  null
  validation {
    condition = var.image_pull_secret_arn != null
    error_message = "Make sure your input value, the conditions satisfied."
  }
}

variable "cluster_id" {
  type    = string
  default = null
  validation {
    condition     = var.cluster_id != null
    error_message = "Make sure your input value, the conditions satisfied."
  }
}

variable "cpu" {
  type    = number
  default = 2048
}

variable "memory" {
  type    = number
  default = 4096
}
