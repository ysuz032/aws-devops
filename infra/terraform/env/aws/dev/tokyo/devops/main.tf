locals {
  repo_url = {
    # ECS Faragate
    appA = "${var.repo_base_url}/appA"
    # EC2
    appB = "${var.repo_base_url}/appB"
    # SPA
    spa = "${var.repo_base_url}/spa"
  }
  repo_name = {
    appA = reverse(split("/", local.repo_url.appA))[0]
    appB = reverse(split("/", local.repo_url.appB))[0]
    spa  = reverse(split("/", local.repo_url.spa))[0]
  }
  build_spec = {
    appA = "devops/codebuild/env/dev/appA/buildspec.yml"
    appB = "devops/codebuild/env/dev/appB/buildspec.yml"
    spa  = "devops/codebuild/env/dev/spa/buildspec.yml"
  }
  image_definitions = {
    # ECS Fargate
    appA = "devops/codebuild/env/dev/appA/imagedefinitions.json"
  }
  ecs_cluster = {
    # ECS Fargate
    appA = "${var.name_prefix}-ecs-cluster"
  }
  ecs_services = {
    # ECS Fargate
    appA = ["ecs-service-appA-01"]
  }
}

data "aws_caller_identity" "current" {}

module "iam_codebuild" {
  source      = "../../../../modules/iam-codebuild"
  role_name   = "${var.name_prefix}-role-codebuild-default"
  policy_name = "${var.name_prefix}-policy-codebuild"
}

module "iam_codepipeline" {
  source      = "../../../../modules/iam-codepipeline"
  role_name   = "${var.name_prefix}-role-codepipeline-default"
  policy_name = "${var.name_prefix}-policy-codepipeline"
}

module "iam_codedeploy" {
  source      = "../../../../modules/iam-codedeploy"
  role_name   = "${var.name_prefix}-role-codedeploy-default"
  policy_name = "${var.name_prefix}-policy-codedeploy"
}

module "iam_eventbridge" {
  source      = "../../../../modules/iam-eventbridge"
  role_name   = "${var.name_prefix}-role-eventbridge-devops-default"
  policy_name = "${var.name_prefix}-policy-eventbridge-devops"
}

# CloudWatch EventBus
module "event_bus" {
  source         = "../../../../modules/eventbus"
  event_bus_name = var.event_bus_name
}

# S3 Bucket
module "s3_bucket_codebuild" {
  source      = "../../../../modules/s3"
  bucket_name = var.build_bucket
}

module "s3_bucket_codepipeline" {
  source      = "../../../../modules/s3"
  bucket_name = var.artifact_bucket
}

# ECS - appA
module "codebuild_appA" {
  source              = "../../../../modules/codebuild"
  project_name        = "${var.name_prefix}-codebuild-appA"
  aws_region          = var.aws_region
  codecommit_repo_url = local.repo_url.appA
  buildspec           = local.build_spec.appA
  build_bucket        = module.s3_bucket_codebuild.name
  vpc_id              = var.vpc_id
  subnets             = var.subnets
  security_group_ids  = var.security_group_ids
  role_arn            = module.iam_codebuild.role_arn
}

module "codepipeline_appA" {
  source                 = "../../../../modules/codepipeline-ecs"
  pipeline_name          = "${var.name_prefix}-codepipeline-appA"
  artifact_bucket        = module.s3_bucket_codepipeline.name
  role_arn               = module.iam_codepipeline.role_arn
  codecommit_role_arn    = null
  codecommit_repo        = local.repo_name.appA
  branch                 = var.repo_branch
  codebuild_project_name = module.codebuild_appA.project_name
  ecs_cluster            = local.ecs_cluster.appA
  ecs_services           = local.ecs_services.appA
  image_definitions      = local.image_definitions.appA
}

module "eventbridge_appA" {
  source          = "../../../../modules/eventbridge"
  event_bus_name  = module.event_bus.name
  rule_name       = "${var.name_prefix}-event-codecommit-push-appA"
  pipeline_arn    = module.codepipeline_appA.pipeline_arn
  codecommit_repo = local.repo_name.appA
  branch          = var.repo_branch
  aws_region      = var.aws_region
  aws_account_id  = data.aws_caller_identity.current.account_id
  role_arn        = module.iam_eventbridge.role_arn
}

# EC2 - appB
module "codebuild_appB" {
  source              = "../../../../modules/codebuild"
  project_name        = "${var.name_prefix}-codebuild-appB"
  aws_region          = var.aws_region
  codecommit_repo_url = local.repo_url.appB
  buildspec           = local.build_spec.appB
  build_bucket        = module.s3_bucket_codebuild.name
  vpc_id              = var.vpc_id
  subnets             = var.subnets
  security_group_ids  = var.security_group_ids
  role_arn            = module.iam_codebuild.role_arn
}

module "codedeploy_appB" {
  source                = "../../../../modules/codedeploy-ec2"
  application_name      = "${var.name_prefix}-codedeploy-appB"
  deployment_group_name = "${var.name_prefix}-deployment-group-appB"
  role_arn              = module.iam_codedeploy.role_arn
  ec2_tag_key           = "Name"
  ec2_tag_value         = "${var.name_prefix}-ec2-appB"
}

module "codepipeline_appB" {
  source                      = "../../../../modules/codepipeline-ec2"
  pipeline_name               = "${var.name_prefix}-codepipeline-appB"
  artifact_bucket             = module.s3_bucket_codepipeline.name
  role_arn                    = module.iam_codepipeline.role_arn
  codecommit_role_arn         = null
  codecommit_repo             = local.repo_name.appB
  branch                      = var.repo_branch
  codebuild_project_name      = module.codebuild_appB.project_name
  codedeploy_application      = module.codedeploy_appB.application_name
  codedeploy_deployment_group = module.codedeploy_appB.deployment_group_name
}

module "eventbridge_appB" {
  source          = "../../../../modules/eventbridge"
  event_bus_name  = module.event_bus.name
  rule_name       = "${var.name_prefix}-event-codecommit-push-appB"
  pipeline_arn    = module.codepipeline_appB.pipeline_arn
  codecommit_repo = local.repo_name.appB
  branch          = var.repo_branch
  aws_region      = var.aws_region
  aws_account_id  = data.aws_caller_identity.current.account_id
  role_arn        = module.iam_eventbridge.role_arn
}
