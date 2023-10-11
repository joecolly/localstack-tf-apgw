data "archive_file" "zip" {
  type       = "zip"
  source_dir = "${path.root}/${var.lambda_dir}/${var.lambda_name}"

  output_path = "${path.root}/${var.output_dir}/${var.lambda_name}_latest.zip"
}

resource "aws_lambda_function" "lambda_defination" {
  function_name    = "${var.lambda_name}-${var.workspace}"
  runtime          = var.runtime
  role             = var.iam_role
  handler          = "${var.lambda_name}.handler"
  timeout          = var.timeout
  memory_size      = var.memory_size
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  layers           = var.layers

  dynamic "environment" {
    for_each = var.environment == null ? [] : [var.environment]
    content {
      variables = var.environment
    }
  }

  dynamic "vpc_config" {
    for_each = var.subnet_ids == null || var.security_group_ids == null ? [] : ["once"]
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  tracing_config {
    mode = "Active"
  }
}

//Allow APGW
resource "aws_lambda_permission" "enable_apgw" {
  count         = var.enable_apgw ? 1 : 0
  function_name = aws_lambda_function.lambda_defination.function_name
  statement_id  = "Allow-${var.lambda_name}-APIGatewayExecution"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
}

//Allow Cognito
resource "aws_lambda_permission" "enable_cognito_trigger" {
  count         = var.enable_cognito_trigger ? 1 : 0
  function_name = aws_lambda_function.lambda_defination.function_name
  statement_id  = "Allow-${var.lambda_name}-Cognito"
  action        = "lambda:InvokeFunction"
  principal     = "cognito-idp.amazonaws.com"
}

//Allow Sqs
resource "aws_lambda_event_source_mapping" "enable_sqs" {
  count            = var.enable_sqs ? 1 : 0
  function_name    = aws_lambda_function.lambda_defination.function_name
  batch_size       = var.sqs_batch_size
  event_source_arn = var.sqs_queue_arn
}

//Allow Sns
resource "aws_lambda_permission" "enable_sns" {
  count         = var.enable_sns ? 1 : 0
  function_name = aws_lambda_function.lambda_defination.function_name
  statement_id  = "Allow_SNS"
  action        = "lambda:InvokeFunction"
  principal     = "sns.amazonaws.com"
}

resource "aws_sns_topic_subscription" "this" {
  count     = var.enable_sns ? 1 : 0
  topic_arn = var.subscription_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda_defination.arn
}

//Allow Dynamo
resource "aws_lambda_permission" "enable_dynamo_stream" {
  count         = var.enable_dynamo_stream ? 1 : 0
  statement_id  = "DynamoTrigger"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_defination.function_name
  principal     = "dynamodb.amazonaws.com"
  source_arn    = var.dynamo_stream_arn
}

resource "aws_lambda_event_source_mapping" "enable_dynamo_stream" {
  count             = var.enable_dynamo_stream ? 1 : 0
  batch_size        = var.dynamo_stream_batch_size
  event_source_arn  = var.dynamo_stream_arn
  function_name     = aws_lambda_function.lambda_defination.function_name
  starting_position = "LATEST"
  enabled           = var.enable_dynamo_stream
}

//Allow S3
resource "aws_s3_bucket_notification" "this" {
  count  = var.enable_s3 ? 1 : 0
  bucket = var.s3_bucket_id
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_defination.arn
    events              = var.s3_trigger_events
  }
}
resource "aws_lambda_permission" "enable_S3" {
  count         = var.enable_s3 ? 1 : 0
  function_name = aws_lambda_function.lambda_defination.function_name
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

//CronJob

resource "aws_cloudwatch_event_rule" "this" {
  count               = var.enable_cron ? 1 : 0
  name                = "Cron-${var.lambda_name}-${var.workspace}"
  schedule_expression = "rate(${var.cron_rate_min} minutes)"
}

resource "aws_cloudwatch_event_target" "this" {
  count     = var.enable_cron ? 1 : 0
  rule      = aws_cloudwatch_event_rule.this[count.index].name
  target_id = var.lambda_name
  arn       = aws_lambda_function.lambda_defination.arn
}

resource "aws_lambda_permission" "enable_cron" {
  count         = var.enable_cron ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_defination.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this[count.index].arn
}

output "arn" {
  value = aws_lambda_function.lambda_defination.arn
}

output "name" {
  value = var.lambda_name
}

output "invoke_arn" {
  value = aws_lambda_function.lambda_defination.invoke_arn
}
