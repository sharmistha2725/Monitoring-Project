terraform {
  backend "s3" {
    bucket         = "backends3-tfstate"
    key            = "envs/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "backendtable"
    encrypt        = true
    use_lockfile   = true
 
  }
}