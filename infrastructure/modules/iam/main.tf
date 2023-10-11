resource "aws_iam_role" "lambda_execution_role" {
  assume_role_policy = file("${path.module}/policies/assume_role.json")
  name               = "lambda_execution_role_${var.stage}"
}


resource "aws_iam_policy" "lambda_execution_policy" {
  name = "lambda_execution_policy_${var.stage}"
  policy = templatefile("${path.module}/policies/lambda_execution_role.json", {})
}

resource "aws_iam_policy_attachment" "lambda_execution_policy_attachment" {
  name       = "lamdaa_execution_policy_attachment_${var.stage}"
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  roles      = [aws_iam_role.lambda_execution_role.name]
}

#resource "aws_iam_role" "authorization_role" {
#  name               = "APGW_Authorization_Role_${var.stage}"
#  assume_role_policy = file("${path.module}/policies/apgw_assume_role.json")
#}
#
#resource "aws_iam_role_policy" "auth_policy" {
#  name   = "api_auth_policy_${var.stage}"
#  role   = aws_iam_role.authorization_role.id
#  policy = file("${path.module}/policies/apgw_lambda_invoke_policy.json")
#}
#
#resource "aws_iam_role" "authenticated" {
#  name = "authenticated_${var.stage}"
#  assume_role_policy = templatefile("${path.module}/policies/cognito_assume_role.json", {
#    admin_identity_pool_id          = var.admin_identity_pool_id,
#    member_identity_pool_id         = var.member_identity_pool_id,
#    employee_identity_pool_id       = var.employee_identity_pool_id,
#    business_owner_identity_pool_id = var.business_owner_identity_pool_id
#  })
#}
#
#resource "aws_iam_role_policy" "authenticated" {
#  name = "authenticated_policy_${var.stage}"
#  role = aws_iam_role.authenticated.id
#  policy = templatefile("${path.module}/policies/cognito.json", {
#    api_gateway_execution_arn = var.api_gateway_execution_arn
#  })
#}
