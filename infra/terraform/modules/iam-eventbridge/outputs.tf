output "role_arn" {
  description = "The ARN of the IAM role for EventBridge"
  value       = aws_iam_role.eventbridge.arn
}
