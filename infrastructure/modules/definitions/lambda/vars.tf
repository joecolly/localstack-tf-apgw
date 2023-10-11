variable "workspace" {}
variable "lambda_name" {}
variable "iam_role" { default = "*" }
variable "timeout" {}
variable "memory_size" {}
variable "lambda_dir" {}
variable "subnet_ids" { default = null }
variable "security_group_ids" { default = null }


variable "environment" {
  default = null
  type    = map(string)
}

variable "runtime" { default = "nodejs16.x" }
variable "enable_apgw" { default = false }
variable "enable_cognito_trigger" { default = false }
variable "source_dir" { default = "../../src/lambdas" }
variable "output_dir" { default = "../../tmp" }
variable "layers" { default = [] }
variable "enable_sqs" { default = false }
variable "sqs_queue_arn" { default = "" }
variable "sqs_batch_size" { default = 10 }
variable "enable_dynamo_stream" { default = false }
variable "enable_s3" { default = false }
variable "s3_bucket_arn" { default = "" }
variable "s3_bucket_id" { default = "" }
variable "dynamo_stream_batch_size" { default = "1" }
variable "dynamo_stream_arn" { default = "" }
variable "s3_trigger_events" { default = ["s3:ObjectCreated:Post"] }
variable "enable_cron" { default = false }
variable "enable_sns" { default = false }
#variable "alarm_sns_topic_arn" {}
// Defaulted to 24 hours, 24 * 60 
variable "cron_rate_min" { default = 1440 }
variable "subscription_topic_arn" { default = "" }

