Example of Terraform error when attempting to create API Gateway Method Settings.

Steps to reproduce

1. Run `localstack start`
2. Change directory `cd infrastructure/deployment`
3. Run `terraform init` and `terraform workspace new local` (or whatever you want to call your workspace)
4. Run `terraform apply`

Error returned:

```
│ Error: updating API Gateway Stage failed: BadRequestException: Invalid method setting path: /test/GET/throttling/burstLimit. Must be one of: [/deploymentId, /description, /cacheClusterEnabled, /cacheClusterSize, /clientCertificateId, /accessLogSettings, /accessLogSettings/destinationArn, /accessLogSettings/format, /{resourcePath}/{httpMethod}/metrics/enabled, /{resourcePath}/{httpMethod}/logging/dataTrace, /{resourcePath}/{httpMethod}/logging/loglevel, /{resourcePath}/{httpMethod}/throttling/burstLimit/{resourcePath}/{httpMethod}/throttling/rateLimit/{resourcePath}/{httpMethod}/caching/ttlInSeconds, /{resourcePath}/{httpMethod}/caching/enabled, /{resourcePath}/{httpMethod}/caching/dataEncrypted, /{resourcePath}/{httpMethod}/caching/requireAuthorizationForCacheControl, /{resourcePath}/{httpMethod}/caching/unauthorizedCacheControlHeaderStrategy, /*/*/metrics/enabled, /*/*/logging/dataTrace, /*/*/logging/loglevel, /*/*/throttling/burstLimit /*/*/throttling/rateLimit /*/*/caching/ttlInSeconds, /*/*/caching/enabled, /*/*/caching/dataEncrypted, /*/*/caching/requireAuthorizationForCacheControl, /*/*/caching/unauthorizedCacheControlHeaderStrategy, /variables/{variable_name}, /tracingEnabled]
│ 
│   with module.apgw.module.testlambda.aws_api_gateway_method_settings.this,
│   on ../modules/definitions/apgw/method/main.tf line 22, in resource "aws_api_gateway_method_settings" "this":
│   22: resource "aws_api_gateway_method_settings" "this" {
```
