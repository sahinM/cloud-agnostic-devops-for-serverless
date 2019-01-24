terraform {
  backend "s3" {
    key            = "terraform.tfstate"
    region         = "${var.backend_region}"
  }
}
