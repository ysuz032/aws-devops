variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID for the CodeBuild project"
  type        = string
}

variable "subnets" {
  description = "The subnets for the CodeBuild project"
  type        = list(string)
}

variable "security_group_ids" {
  description = "The security group IDs for the CodeBuild project"
  type        = list(string)
}

variable "build_bucket" {
  description = "The S3 bucket for CodeBuild"
  type        = string
}

variable "artifact_bucket" {
  description = "The S3 bucket for CodePipeline artifacts"
  type        = string
}

variable "name_prefix" {
  description = "The prefix to use for naming resources"
  type        = string
}

variable "repo_base_url" {
  description = "The base URL of the CodeCommit repositories"
  type        = string
}

variable "repo_branch" {
  description = "The branch name of the CodeCommit repositories"
  type        = string
}

variable "event_bus_name" {
  description = "The name of the EventBridge event bus to use"
  type        = string
  default     = "default"
}
