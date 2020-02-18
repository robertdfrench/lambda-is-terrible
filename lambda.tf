provider "aws" {
	region = "us-east-1"
}

resource "aws_lambda_function" "hit_counter" {
	filename = "lambda.zip"
	source_code_hash = filebase64sha256("lambda.zip")
	runtime = "python3.8"

	function_name = "hit_counter"
	handler = "lambda.hit_counter"
	role = aws_iam_role.hit_counter.arn

	depends_on = [aws_iam_role_policy_attachment.allow_update_counters]
}

resource "aws_dynamodb_table" "counters" {
	name = "counters"
	hash_key = "ip"
	attribute {
		name = "ip"
		type = "S"
	}
	billing_mode = "PAY_PER_REQUEST"
}

resource "aws_cloudwatch_log_group" "hit_counter" {
	name = "/aws/lambda/hit_counter"
	retention_in_days = 14
}

resource "aws_iam_role" "hit_counter" {
	name = "hit_counter"
	assume_role_policy = data.aws_iam_policy_document.allow_lambda_assume.json
}

data "aws_iam_policy_document" "allow_lambda_assume" {
	statement {
		actions = ["sts:AssumeRole"]

		principals {
			type = "Service"
			identifiers = ["lambda.amazonaws.com"]
		}
	}
}

resource "aws_iam_role_policy_attachment" "allow_update_counters" {
	role = aws_iam_role.hit_counter.name
	policy_arn = aws_iam_policy.allow_update_counters.arn
}

resource "aws_iam_policy" "allow_update_counters" {
	name = "allow_update_counters"
	description = "Allow Lambda to update 'Counters' table"
	policy = data.aws_iam_policy_document.allow_update_counters.json
}

data "aws_iam_policy_document" "allow_update_counters" {
	statement {
		actions = ["dynamodb:UpdateItem","dynamodb:Scan"]
		resources = ["arn:aws:dynamodb:*:*:table/counters"]
	}
}
