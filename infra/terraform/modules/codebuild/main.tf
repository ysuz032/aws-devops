resource "aws_codebuild_project" "this" {
  name          = var.project_name
  description   = "CodeBuild project for ECS Fargate"
  build_timeout = "5"
  service_role  = var.role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }
  }

  logs_config {
    cloudwatch_logs {
      status      = "ENABLED"
      group_name  = "/aws/codebuild/${var.project_name}"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${var.build_bucket}/build-log"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = var.codecommit_repo_url
    git_clone_depth = 1
    buildspec       = var.buildspec
  }

  cache {
    type     = "S3"
    location = "${var.build_bucket}/cache"
  }

  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.subnets
    security_group_ids = var.security_group_ids
  }
}
