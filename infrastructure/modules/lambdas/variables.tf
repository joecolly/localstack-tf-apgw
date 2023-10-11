variable "workspace" {}
variable "iam_role" {}
variable "region" {}
#variable "account_id" {}
variable "stage" {}
variable "lambda_dir" {
  default = "../../../src/lambdas"
}

variable "test_main_vpc_pv_subnet_ids" { default = [] }
variable "lambda_sg_id" { default = [] }

variable "lambda_trigger_dir" {
  default = "../../../src/triggers"
}
variable "environment" {
  type    = map(string)
  default = null
}
