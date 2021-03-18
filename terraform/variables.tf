variable node_count {
  description = "Number of Nodes"
  type        = number
}

variable instance_type {
  description = "Type of EC2 instance to use"
  type        = string
}

variable cluster_id {
  description = "Cluster unique identifier - 8 character"
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