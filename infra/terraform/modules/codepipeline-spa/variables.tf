variable "pipeline_name" {
  description = "The name of the CodePipeline"
  type        = string
}

variable "role_arn" {
  description = "The role ARN for the CodePipeline"
  type        = string
}

variable "artifact_bucket" {
  description = "The S3 bucket for storing pipeline artifacts"
  type        = string
}

variable "codecommit_role_arn" {
  description = "The role ARN for CodeCommit actions"
  type        = string
}

variable "codecommit_repo" {
  description = "The name of the CodeCommit repository"
  type        = string
}

variable "branch" {
  description = "The branch name in the CodeCommit repository"
  type        = string
}

variable "codebuild_project_name" {
  description = "The name of the CodeBuild project"
  type        = string
}

variable "deploy_target_bucket" {
  description = "The S3 bucket where deployment artifacts are stored"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function for cache invalidation"
  type        = string
}

variable "distribution_id" {
  description = "The ID of the CloudFront distribution"
  type        = string
}