
resource "aws_api_gateway_method" "resource_options" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "resource_options_integration" {
  http_method = aws_api_gateway_method.resource_options.http_method
  resource_id = var.resource_id
  rest_api_id = var.rest_api_id
  type        = "MOCK"
  request_templates = {
    "application/json" = <<TEMPLATE
      {"statusCode": 200}
    TEMPLATE
  }
}

resource "aws_api_gateway_method_response" "resource_options_method_response" {
  depends_on  = [aws_api_gateway_method.resource_options]
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = "OPTIONS"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "resource_options_integration_response" {
  depends_on  = [aws_api_gateway_integration.resource_options_integration]
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method_response.resource_options_method_response.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = var.allowed_methods
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}
