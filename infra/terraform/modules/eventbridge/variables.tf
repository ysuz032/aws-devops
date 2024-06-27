variable "rule_name" {
  description = "Name of the EventBridge rule"
  type        = string
}

variable "pipeline_arn" {
  description = "ARN of the CodePipeline"
  type        = string
}

variable "codecommit_repo" {
  description = "Name of the CodeCommit repository"
  type        = string
}

variable "branch" {
  description = "Branch name of the CodeCommit repository"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "event_bus_name" {
  description = "The name of the event bus to use"
  type        = string
  default     = "default"
}

variable "role_arn" {
  description = "IAM Role ARN for EventBridge"
  type        = string
}