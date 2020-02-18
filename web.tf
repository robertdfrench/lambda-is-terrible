output "url" {
	value = aws_api_gateway_deployment.hit_counter.invoke_url
}

resource "aws_api_gateway_deployment" "hit_counter" {
	rest_api_id = aws_api_gateway_rest_api.hit_counter.id
	stage_name = "production"
	depends_on = [aws_api_gateway_integration.hit_counter]
}

resource "aws_lambda_permission" "allow_lambda_invocation" {
	statement_id = "AllowExecutionFromAPIGateway"
	action = "lambda:InvokeFunction"
	function_name = aws_lambda_function.hit_counter.function_name
	principal = "apigateway.amazonaws.com"
	source_arn = join(":", [
		"arn:aws:execute-api",
		local.region,
		local.account,
		"${local.api}/*/${local.method}${local.path}"
	])
}

locals {
	api = aws_api_gateway_rest_api.hit_counter.id
	method = aws_api_gateway_method.hit_counter.http_method
	path = aws_api_gateway_resource.hit_counter.path
	region = data.aws_region.current.name
	account = data.aws_caller_identity.current.account_id
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_api_gateway_integration" "hit_counter" {
	rest_api_id = aws_api_gateway_rest_api.hit_counter.id
	resource_id = aws_api_gateway_resource.hit_counter.id
	http_method = aws_api_gateway_method.hit_counter.http_method
	integration_http_method = "POST"
	type = "AWS_PROXY"
	uri = aws_lambda_function.hit_counter.invoke_arn
}

resource "aws_api_gateway_method" "hit_counter" {
	http_method = "GET"
	authorization = "NONE"
	rest_api_id = aws_api_gateway_rest_api.hit_counter.id
	resource_id = aws_api_gateway_resource.hit_counter.id
}

resource "aws_api_gateway_resource" "hit_counter" {
	path_part = "hit_counter"
	parent_id = aws_api_gateway_rest_api.hit_counter.root_resource_id
	rest_api_id = aws_api_gateway_rest_api.hit_counter.id
}

resource "aws_api_gateway_rest_api" "hit_counter" {
	name = "hit_counter"
}
