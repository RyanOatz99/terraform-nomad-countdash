variable "template_version" {
  description = "The base-template to use"
  type = string
  default = "default"
}

# -----------------------------------------------

variable "job_name" {
  description = "The name of the Nomad job"
  type = string
  default = "countdash"
}

variable "settings" {
  description = "Parameters used to customize the job. Overrides default values set in template. See README.md for more details."
  type = any
  default = {}
}

# -----------------------------------------------

variable "task_enabled_api" {
  description = "Enable the api-task"
  type = bool
  default = true
}

variable "task_enabled_dashboard" {
  description = "Enable the dashboard-task"
  type = bool
  default = true
}

variable "expose_dashboard_port" {
  description = "Expose the dashboard directly on specified host port."
  type = number
  default = 9002
}
