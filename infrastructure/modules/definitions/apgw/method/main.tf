resource "aws_api_gateway_method" "this" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.resource_id
  http_method   = var.method
  authorization = var.authorization
  authorizer_id = var.authorizer_id
}

resource "aws_api_gateway_integration" "this" {
  depends_on              = [aws_api_gateway_method.this]
  rest_api_id             = var.rest_api_id
  resource_id             = var.resource_id
  http_method             = var.method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  passthrough_behavior    = var.passthrough_behavior
  request_templates       = var.request_templates
  content_handling        = "CONVERT_TO_TEXT"
}

#resource "aws_api_gateway_method_settings" "this" {
#  rest_api_id = var.rest_api_id
#  stage_name  = var.stage_name
#  method_path = "${trimprefix(var.path, "/")}/${var.method}"
#
#  settings {
#    metrics_enabled        = var.metrics_enabled
#    logging_level          = var.logging_level
#    caching_enabled        = var.caching_enabled
#    cache_ttl_in_seconds   = var.cache_ttl_in_seconds
#    cache_data_encrypted   = var.cache_data_encrypted
#    throttling_rate_limit  = var.rate_limit.rate
#    throttling_burst_limit = var.rate_limit.burst
#  }
#}

resource "aws_api_gateway_method_response" "method_response_2xx" {
  depends_on      = [aws_api_gateway_method.this]
  rest_api_id     = var.rest_api_id
  resource_id     = var.resource_id
  http_method     = var.method
  status_code     = "200"
  response_models = var.response_models
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_2xx" {
  depends_on  = [aws_api_gateway_integration.this]
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = var.method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_method_response" "method_response_400" {
  depends_on = [
    aws_api_gateway_method.this,
    aws_api_gateway_method_response.method_response_2xx
  ]
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = var.method
  status_code = "400"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_400" {
  depends_on = [
    aws_api_gateway_integration.this,
    aws_api_gateway_integration_response.integration_response_2xx
  ]
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = var.method
  status_code = "400"

  selection_pattern = ".*httpStatus\":400.*"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = file("${path.module}/response_templates/4xx_5xx.template")
  }
}

resource "aws_api_gateway_method_response" "method_response_403" {
  depends_on = [
    aws_api_gateway_method.this,
    aws_api_gateway_method_response.method_response_400
  ]
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = var.method
  status_code = "403"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_403" {
  depends_on = [
    aws_api_gateway_integration.this,
    aws_api_gateway_integration_response.integration_response_400
  ]
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = var.method
  status_code = "403"

  selection_pattern = ".*httpStatus\":403.*"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = file("${path.module}/response_templates/4xx_5xx.template")
  }
}

resource "aws_api_gateway_method_response" "method_response_500" {
  depends_on = [
    aws_api_gateway_method.this,
    aws_api_gateway_method_response.method_response_403
  ]
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = var.method
  status_code = "500"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_500" {
  depends_on = [
    aws_api_gateway_integration.this,
    aws_api_gateway_integration_response.integration_response_403
  ]
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = var.method
  status_code = "500"

  selection_pattern = ".*httpStatus\":500.*"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = file("${path.module}/response_templates/4xx_5xx.template")
  }
}

output "integration" {
  value = aws_api_gateway_integration.this
}
