resource "aws_codepipeline" "this" {
  name     = var.pipeline_name
  role_arn = var.role_arn

  pipeline_type = "V2"

  artifact_store {
    location = var.artifact_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]
      role_arn         = var.codecommit_role_arn
      configuration = {
        RepositoryName       = var.codecommit_repo
        BranchName           = var.branch
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }

  stage {
    name = "Approval"

    action {
      name     = "ManualApproval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        CustomData = "Please review the build output before deployment."
      }
    }
  }

  dynamic "stage" {
    for_each = toset(var.ecs_services)
    content {
      name = "Deploy${index(var.ecs_services, stage.value) + 1}"

      action {
        name            = "Deploy"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "ECS"
        input_artifacts = ["build_output"]
        version         = "1"
        configuration = {
          ClusterName = var.ecs_cluster
          ServiceName = stage.value
          FileName    = var.image_definitions
        }
      }
    }
  }
}
