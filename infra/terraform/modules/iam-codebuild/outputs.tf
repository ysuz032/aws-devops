output "role_arn" {
  description = "The ARN of the IAM role for CodeBuild"
  value       = aws_iam_role.codebuild.arn
}
