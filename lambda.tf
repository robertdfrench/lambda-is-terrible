provider "aws" {
	region = "us-east-1"
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
