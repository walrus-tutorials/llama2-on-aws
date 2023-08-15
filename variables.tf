# @options ["t3.xlarge","t3.2xlarge"]
variable "instance_type" {
  type = string
  description = "Instance type"
  default = "t3.2xlarge"
}

variable "disk_size" {
  type = number
  description = "Root disk size in GiB"
  default = 80
}


variable "vpc_name" {
  type = string
  description = "VPC Name"
  default = ""
}

variable "security_group_name" {
  type = string
  description = "Security group Name"
  default = ""
}

variable "instance_name" {
  type        = string
  default     = "llama2-demo"
}

variable "key_name" {
  type = string
  description = "Key pair name"
  default = ""
}
