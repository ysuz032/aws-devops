variable "application_name" {
  description = "Name of the CodeDeploy application"
  type        = string
}

variable "deployment_group_name" {
  description = "Name of the CodeDeploy deployment group"
  type        = string
}

variable "role_arn" {
  description = "IAM Role ARN for CodeDeploy"
  type        = string
}

variable "ec2_tag_key" {
  description = "Tag key for identifying EC2 instances"
  type        = string
}

variable "ec2_tag_value" {
  description = "Tag value for identifying EC2 instances"
  type        = string
}