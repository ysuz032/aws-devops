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

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      version         = "1"
      input_artifacts = ["build_output"]
      run_order       = 1
      configuration = {
        BucketName = var.deploy_target_bucket
        Extract    = "true"
      }
    }

    action {
      name            = "ClearCache"
      category        = "Invoke"
      owner           = "AWS"
      provider        = "Lambda"
      version         = "1"
      input_artifacts = ["build_output"]
      run_order       = 2 # Run sequentially
      configuration = {
        FunctionName = var.lambda_function_name
        UserParameters = jsonencode({
          distributionId = var.distribution_id
        })
      }
    }
  }
}