variable "endpoint_path" {
  description = "The GET endpoint path"
  type = string
  default = "method"
}

variable "myregion" {
    description = "AWS region"
    type = string
    default = "us-east-1"
}

variable "accountId" {
    description = "AWS account ID"
    type = string
}

variable "lambda_function_name" {
    description = "What to name the lambda function"
    type = string
    default = "cypress-lambda"
}