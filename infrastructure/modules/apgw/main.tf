resource "aws_api_gateway_rest_api" "api" {
  name               = "Test Api ${var.stage}"
  binary_media_types = ["image/png", "image/jpg", "image/jpeg"]
}

resource "aws_api_gateway_deployment" "this" {
  depends_on  = [module.testlambda.integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "v1"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_method_settings" "settings" {
  depends_on  = [aws_api_gateway_deployment.this]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "v1"
  method_path = "*/*"
  settings {
    logging_level      = "INFO"
    data_trace_enabled = true
    metrics_enabled    = true
  }
}
