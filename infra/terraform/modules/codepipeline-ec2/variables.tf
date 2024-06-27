variable "pipeline_name" {
  description = "The name of the CodePipeline"
  type        = string
}

variable "artifact_bucket" {
  description = "The S3 bucket for pipeline artifacts"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role for CodePipeline"
  type        = string
}

variable "codecommit_repo" {
  description = "The name of the CodeCommit repository"
  type        = string
}

variable "codecommit_role_arn" {
  description = "Role ARN to pull source code from codecommit"
  type        = string
  nullable    = true
}

variable "branch" {
  description = "The branch of the CodeCommit repository"
  type        = string
}

variable "codebuild_project_name" {
  description = "The name of the CodeBuild project"
  type        = string
}

variable "codedeploy_application" {
  description = "The name of the CodeDeploy application"
  type        = string
}

variable "codedeploy_deployment_group" {
  description = "The name of the CodeDeploy deployment group"
  type        = string
}
