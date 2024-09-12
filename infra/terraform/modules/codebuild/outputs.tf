output "project_name" {
  description = "The name of the CodeBuild"
  value       = aws_codebuild_project.this.name
}
