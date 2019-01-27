terraform {
  backend "s3" {
    bucket         = ""
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = ""
  }
}