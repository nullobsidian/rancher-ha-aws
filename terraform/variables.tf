variable node_count {
  description = "Number of Nodes"
  type        = number
}

variable instance_type {
  description = "Type of EC2 instance to use"
  type        = string
}

variable cluster_id {
  description = "Cluster unique identifier"
  type        = string
}

variable environment {
  description = "Name of the environment"
  type        = string
}

variable k8s_version {
  description = "Kuberentes Version"
  type = string
}

variable docker_version {
  description = "Docker Version"
  type = string
  default = "20.10"
}
