module "test_cors" {
  source          = "../definitions/apgw/cors"
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.test.id
  allowed_methods = "'OPTIONS,GET'"
}
