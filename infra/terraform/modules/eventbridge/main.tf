resource "aws_cloudwatch_event_rule" "codecommit_push_rule" {
  name           = var.rule_name
  description    = "Trigger CodePipeline on CodeCommit push"
  event_bus_name = var.event_bus_name
  event_pattern = jsonencode({
    "source" : ["aws.codecommit"],
    "detail-type" : ["CodeCommit Repository State Change"],
    "resources" : ["arn:aws:codecommit:${var.aws_region}:${var.aws_account_id}:${var.codecommit_repo}"],
    "detail" : {
      "event" : ["referenceUpdated"],
      "referenceName" : ["${var.branch}"]
    }
  })
}

resource "aws_cloudwatch_event_target" "codecommit_push_target" {
  rule           = aws_cloudwatch_event_rule.codecommit_push_rule.name
  event_bus_name = var.event_bus_name
  target_id      = "codepipeline"
  arn            = var.pipeline_arn
  role_arn       = var.role_arn
}
