output "pipeline_name" {
  description = "The name of the Codepipeline"
  value       = aws_codepipeline.this.name
}

output "pipeline_arn" {
  description = "The arn of the Codepipeline"
  value       = aws_codepipeline.this.arn
}