
output "lambda_execution_role" {
  value = aws_iam_role.lambda_execution_role.arn
}

#output "auth_lambda_execution_role" {
#  value = aws_iam_role.authorization_role.arn
#}
#
#output "cognito_role_arn" {
#  value = aws_iam_role.authenticated.arn
#}
