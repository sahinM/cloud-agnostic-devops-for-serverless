terraform {
  backend "s3" {
    bucket         = "${var.backend_bucket_name}"
    key            = "terraform.tfstate"
    region         = "${var.backend_region}"
    dynamodb_table = "${var.backend_table_name"}"
  }
}
