data "aws_caller_identity" "current" {}

resource "aws_api_gateway_rest_api" "api" {
  name = var.api_gw_name
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  depends_on = [
    aws_api_gateway_integration.request_method_integration,
    aws_api_gateway_integration_response.response_method_integration
  ]
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name = var.stage_name
}

resource "aws_api_gateway_usage_plan" "gw_usageplan" {
  count = "${var.lambda_name == "post-task" ? 1 : 0}"
  name = "gw_usageplan"
  api_stages {
    api_id = aws_api_gateway_rest_api.api.id
    stage  = aws_api_gateway_stage.stage.stage_name
  }
}

resource "aws_api_gateway_api_key" "gw_api_key" {
  count = "${var.lambda_name == "post-task" ? 1 : 0}"
  name = "gw_api_key"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  count         = "${var.lambda_name == "post-task" ? 1 : 0}"
  key_id        = aws_api_gateway_api_key.gw_api_key[count.index].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.gw_usageplan[count.index].id
}



resource "aws_api_gateway_resource" "api_resource" {
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = var.lambda_name
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "request_method" {
  authorization = var.lambda_authorization
  http_method = var.method
  resource_id = aws_api_gateway_resource.api_resource.id
  rest_api_id = aws_api_gateway_rest_api.api.id
  api_key_required = var.lambda_api_key_required
}

resource "aws_api_gateway_integration" "request_method_integration" {
  http_method = aws_api_gateway_method.request_method.http_method
  resource_id = aws_api_gateway_resource.api_resource.id
  rest_api_id = aws_api_gateway_rest_api.api.id
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/${var.deployment}/functions/${var.lambda_arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "response_method" {
  http_method = aws_api_gateway_integration.request_method_integration.http_method
  resource_id = aws_api_gateway_resource.api_resource.id
  rest_api_id = aws_api_gateway_rest_api.api.id
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "response_method_integration" {
  http_method = aws_api_gateway_method_response.response_method.http_method
  resource_id = aws_api_gateway_resource.api_resource.id
  rest_api_id = aws_api_gateway_rest_api.api.id
  status_code = aws_api_gateway_method_response.response_method.status_code
}

resource "aws_lambda_permission" "apigw-lambda-allow" {
  action = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal = "apigateway.amazonaws.com"
  statement_id = "AllowExecutionFromApiGateway"
  depends_on = [aws_api_gateway_rest_api.api,aws_api_gateway_resource.api_resource]
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/*/${var.lambda_name}"
}
