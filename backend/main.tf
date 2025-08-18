terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"  
    }
  }
}

provider "aws" {
  region = "us-east-1"

}

resource "aws_s3_bucket" "tf_state" {
  bucket = "backends3-tfstate"
}

resource "aws_dynamodb_table" "tf_state_lock" {
  name = "backendtable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}

