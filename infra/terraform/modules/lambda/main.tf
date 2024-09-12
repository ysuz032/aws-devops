data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../../../${var.source_app_dir}"
  output_path = "${path.root}/lambda_src_${var.function_name}.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = var.runtime
  role             = var.role_arn
  handler          = var.handler
}