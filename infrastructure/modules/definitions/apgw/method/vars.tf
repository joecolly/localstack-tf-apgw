variable "rest_api_id" {}
variable "resource_id" {}
variable "method" {}
variable "region" {}
variable "lambda_arn" {}

variable "authorizer_id" {
  default = ""
}
variable "authorization" {
  default = "CUSTOM"
}

variable "passthrough_behavior" {
  default = "WHEN_NO_TEMPLATES"
}

variable "request_templates" {
  default = {}
  type    = map(any)
}

variable "response_models" {
  default = {}
  type    = map(any)
}

variable "response_templates" {
  default = {}
  type    = map(any)
}

variable "request_parameters" {
  default = {}
  type    = map(any)
}

variable "path" {}
variable "metrics_enabled" { default = true }
variable "logging_level" { default = "INFO" }
variable "caching_enabled" { default = false }
variable "cache_ttl_in_seconds" { default = 300 }
variable "cache_data_encrypted" { default = false }
variable "rate_limit" {}
variable "stage_name" {}
