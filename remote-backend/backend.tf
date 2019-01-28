terraform {
  backend "s3" {
    bucket         = "cloud-agnostic-cd-or-serverless-264885624248-eu-west-1"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "cloud-agnostic-cd-or-serverless-264885624248-eu-west-1"
  }
}