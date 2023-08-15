# @options ["c5.2xlarge","c5.4xlarge"]
variable "instance_type" {
  type = string
  description = "Instance type"
  default = "c5.2xlarge"
}

variable "ami_id" {
  description = "The ID of the AMI used to launch the EC2 instance"
  default     = "ami-0b0b8676da9af9947"
}

variable "disk_size" {
  type = number
  description = "Root disk size in GiB"
  default = 80
}

variable "disk_iops" {
  type = number
  description = "IOPS of the root disk"
  default = 40000
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

