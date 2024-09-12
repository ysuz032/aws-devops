output "role_arn" {
  description = "The ARN of the IAM role for CodePipeline"
  value       = aws_iam_role.codepipeline.arn
}
