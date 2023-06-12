resource "aws_api_gateway_rest_api" "TeamCypressAPI" {
    name = "TeamCypressAPI"
    description = "This is Team Cypress' API."
}

resource "aws_api_gateway_resource" "TeamCypressAPIresource" {
    rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id
    parent_id = aws_api_gateway_rest_api.TeamCypressAPI.root_resource_id
    path_part = var.endpoint_path
}

resource "aws_api_gateway_method" "TeamCypressAPI_Get_Method" {
    rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id
    resource_id = aws_api_gateway_resource.TeamCypressAPIresource.id
    http_method = "GET"
    authorization = "NONE"
}

resource "aws_api_gateway_method" "TeamCypressAPI_Post_Method" {
    rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id
    resource_id = aws_api_gateway_resource.TeamCypressAPIresource.id
    http_method = "POST"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "Get_integration" {
    rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id
    resource_id = aws_api_gateway_resource.TeamCypressAPIresource.id
    http_method = aws_api_gateway_method.TeamCypressAPI_Get_Method.http_method
    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = aws_lambda_function.lambda.invoke_arn
}

resource "aws_api_gateway_integration" "Post_integration" {
    rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id
    resource_id = aws_api_gateway_resource.TeamCypressAPIresource.id
    http_method = aws_api_gateway_method.TeamCypressAPI_Post_Method.http_method
    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = aws_lambda_function.lambda.invoke_arn
}

resource "aws_api_gateway_method" "TeamCypress_options" {
  rest_api_id   = aws_api_gateway_rest_api.TeamCypressAPI.id
  resource_id   = aws_api_gateway_resource.TeamCypressAPIresource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "TeamCypress_options_200" {
  rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id
  resource_id = aws_api_gateway_resource.TeamCypressAPIresource.id
  http_method = aws_api_gateway_method.TeamCypress_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration" "TeamCypress_options" {
  rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id
  resource_id = aws_api_gateway_resource.TeamCypressAPIresource.id
  http_method = aws_api_gateway_method.TeamCypress_options.http_method

  type = "MOCK"
  
  request_templates = {
    "application/json" = <<EOF
{
  "statusCode" : 200
}
EOF
  }
}

resource "aws_api_gateway_integration_response" "TeamCypress_options" {
  rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id
  resource_id = aws_api_gateway_resource.TeamCypressAPIresource.id
  http_method = aws_api_gateway_method.TeamCypress_options.http_method
  status_code = aws_api_gateway_method_response.TeamCypress_options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_lambda_permission" "teamcypressapigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.TeamCypressAPI.execution_arn}/*/*${aws_api_gateway_resource.TeamCypressAPIresource.path}"
}



resource "aws_api_gateway_deployment" "api_deployment" {
    depends_on = [
        aws_api_gateway_integration.Get_integration, 
        aws_api_gateway_integration.Post_integration, 
        aws_api_gateway_integration.TeamCypress_options 
        
    ]
    rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id

    triggers = {
        redeployment = sha1(jsonencode(aws_api_gateway_rest_api.TeamCypressAPI.body))
    }

    lifecycle {
        create_before_destroy = true
    }
    
}

resource "aws_api_gateway_stage" "api-stage" {
    deployment_id = aws_api_gateway_deployment.api_deployment.id
    rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id
    stage_name = "dev"
}

output "api_url" {
    value = "${aws_api_gateway_deployment.api_deployment.invoke_url}"
}