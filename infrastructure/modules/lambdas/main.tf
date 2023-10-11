module "test_lambda" {
  source              = "../definitions/lambda"
  lambda_dir          = "${path.module}/${var.lambda_dir}"
  # = var.alarm_sns_topic_arn
  iam_role            = var.iam_role
  lambda_name         = "testlambda"
  workspace           = var.workspace
  timeout             = "30"
  memory_size         = "256"
  #layers              = [module.common_layer.arn]
  environment = {
    STAGE      = var.stage
    REGION     = var.region
    TESTENV    = "Hello"
  }
  enable_apgw = true
}
