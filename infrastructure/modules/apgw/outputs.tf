output "id" {
  value = aws_api_gateway_rest_api.api.id
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.api.execution_arn
}

output "name" {
  value = aws_api_gateway_rest_api.api.name
}

output "stage" {
  value = aws_api_gateway_deployment.this
}


output "rest" {
  value = aws_api_gateway_rest_api.api
}

output "deploy" {
  value = aws_api_gateway_deployment.this
}
