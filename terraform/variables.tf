variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "vprofile-eks"
}

variable "node_instance_type" {
  default = "c7i-flex.large"
}

variable "desired_size" {
  default = 2
}

variable "max_size" {
  default = 3
}

variable "min_size" {
  default = 1
}
