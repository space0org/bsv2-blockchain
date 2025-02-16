variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0d52744d6551d851e"  # Ubuntu 22.04 LTS in ap-northeast-1
}
