output "role_arn" {
  description = "The ARN of the IAM role for CodeDeploy"
  value       = aws_iam_role.codedeploy.arn
}