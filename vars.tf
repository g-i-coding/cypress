#API Gateway Variables#
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
    default = "176906365059"
}

variable "lambda_function_name" {
    description = "What to name the lambda function"
    type = string
    default = "cypress-lambda"
}
##VPC Variables
variable "amplify-name" {
  type = string
  default = "cypress-project3"
  description = "The name of the app"

}


variable "amplify-repo" {
  type = string
  default = "https://github.com/Rizi0/amplify"
  description = "Repo amplify pulls from"
}



variable "github_token" {
  type    = string
  default = null
  sensitive = true
}