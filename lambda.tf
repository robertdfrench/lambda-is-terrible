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
