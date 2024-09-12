output "application_name" {
  description = "The name of the CodeDeploy application"
  value       = aws_codedeploy_app.app.name
}

output "deployment_group_name" {
  description = "The name of the CodeDeploy deployment group"
  # convert `{ApplicationNmae}:{DeploymentGroupname}` to `{DeploymentGroupname}`
  value = reverse(split(":", aws_codedeploy_deployment_group.deployment_group.id))[0]
}