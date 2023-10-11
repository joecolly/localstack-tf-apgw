locals {
  environment = terraform.workspace
}

terraform {
  required_version = ">= 0.12.9"

  required_providers {
    aws = {
      version = ">=4.15.1"
    }
  }

  backend "s3" {
    bucket  = "terraform-state"
    key     = "common/terraform.tfstate"
    region  = "eu-west-2"
    profile = "localstack"
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

module "s3" {
  source      = "../modules/s3"
  environment = local.environment
}

module "lambdas" {
  source = "../modules/lambdas"
  workspace = local.environment
  region = var.aws_region
  stage = local.environment
  iam_role = module.iam.lambda_execution_role
  #account_id = data.aws_caller_identity.this.account_id
}

module "iam" {
  source = "../modules/iam"
  stage = local.environment
  api_gateway_execution_arn = module.apgw.execution_arn
}

module "apgw" {
  region = var.aws_region
  stage = local.environment
  source = "../modules/apgw"
  testlambda_arn = module.lambdas.testlambda_arn
}
