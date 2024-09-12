variable "pipeline_name" {
  description = "Name of the CodePipeline"
  type        = string
}

variable "artifact_bucket" {
  description = "S3 bucket for storing artifacts"
  type        = string
}

variable "codecommit_repo" {
  description = "Name of the CodeCommit repository"
  type        = string
}

variable "codecommit_role_arn" {
  description = "Role ARN to pull source code from codecommit"
  type        = string
}

variable "branch" {
  description = "Branch of the CodeCommit repository"
  type        = string
}

variable "ecs_cluster" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_services" {
  description = "ECS services to be deployed"
  type        = list(string)
}

variable "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "role_arn" {
  description = "IAM Role ARN for CodePipeline"
  type        = string
}

variable "image_definitions" {
  description = "Path to imagedefinitions.json file"
  type        = string
}
