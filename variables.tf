
variable instances_per_subnet {
  description = "Number of EC2 instances to deploy"
  type        = number
}

variable instance_type {
  description = "Type of EC2 instance to use"
  type        = string
}

variable project_name {
  description = "Name of the project"
  type        = string
}

variable environment {
  description = "Name of the environment"
  type        = string
}

variable key_name {
  description = "Name of key pair"
  type        = string
}