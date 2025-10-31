variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for monitoring and target"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key name"
  type        = string
  default     = "monitoring-key"
}

variable "public_key_path" {
  description = "Path to your SSH public key"
  type        = string
  default     = "/Users/I756555/.ssh/id_rsa.pub"
}

variable "monitoring_count" {
  description = "Number of monitoring VMs"
  type        = number
  default     = 1
}

variable "target_count" {
  description = "Number of target VMs"
  type        = number
  default     = 1
}
