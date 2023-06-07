resource "aws_api_gateway_rest_api" "TeamCypressAPI" {
    name = "TeamCypressAPI"
    description = "This is Team Cypress' API."
}

resource "aws_api_gateway_resource" "TeamCypressAPIresource" {
    rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id
    parent_id = aws_api_gateway_rest_api.TeamCypressAPI.root_resource_id
    path_part = var.endpoint_path
}

resource "aws_api_gateway_method" "TeamCypressAPI_Get-Method" {
    rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id
    resource_id = aws_api_gateway_resource.TeamCypressAPIresource.id
    http_method = "GET"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
    rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id
    resource_id = aws_api_gateway_resource.TeamCypressAPIresource.id
    http_method = aws_api_gateway_method.TeamCypressAPI_Get-Method.http_method
    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = aws_lambda_function.lambda.invoke_arn
}

resource "aws_lambda_permission" "teamcypressapigw_lambda" {
    statement_id = "AllowExecutionFromAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda.function_name
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.TeamCypressAPI.id}/*/${aws_api_gateway_method.TeamCypressAPI_Get-Method.http_method}${aws_api_gateway_resource.TeamCypressAPIresource.path}"
}

resource "aws_api_gateway_deployment" "api-deployment" {
    rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id

    triggers = {
        redeployment = sha1(jsonencode(aws_api_gateway_rest_api.TeamCypressAPI.body))
    }

    lifecycle {
        create_before_destroy = true
    }
    depends_on = [aws_api_gateway_method.TeamCypressAPI_Get-Method, aws_api_gateway_integration.integration]
}

resource "aws_api_gateway_stage" "api-stage" {
    deployment_id = aws_api_gateway_deployment.api-deployment.id
    rest_api_id = aws_api_gateway_rest_api.TeamCypressAPI.id
    stage_name = "dev"
}

output "api_url" {
    value = "${aws_api_gateway_deployment.api-deployment.invoke_url}"
}