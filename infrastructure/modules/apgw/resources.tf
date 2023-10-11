module "testlambda" {
  source      = "../definitions/apgw/method"
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_deployment.this.stage_name
  rate_limit  = { burst = 10, rate = 20 }
  method      = "GET"
  resource_id = aws_api_gateway_resource.test.id
  path        = aws_api_gateway_resource.test.path
  region      = var.region
  lambda_arn  = var.testlambda_arn
  request_templates = {
    "application/json" : file("${path.module}/templates/testlambda_body_mapping.template")
  }
  authorization = "NONE"
}
