variable "source_app_dir" {
  description = "The directory containing the Lambda source code"
  type        = string
}

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role that Lambda assumes when it executes your function"
  type        = string
}

variable "runtime" {
  description = "Runtime version"
  type        = string
}

variable "handler" {
  description = "The Name of the Lambda function's handler"
  type        = string
}