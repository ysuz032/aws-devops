variable "project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "codecommit_repo_url" {
  description = "URL of the CodeCommit repository"
  type        = string
}

variable "buildspec" {
  description = "Buildspec file location"
  type        = string
}

variable "build_bucket" {
  description = "S3 bucket for CodeBuild"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for CodeBuild"
  type        = string
}

variable "subnets" {
  description = "Subnets for CodeBuild"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Group IDs for CodeBuild"
  type        = list(string)
}

variable "role_arn" {
  description = "IAM Role ARN for CodeBuild"
  type        = string
}
