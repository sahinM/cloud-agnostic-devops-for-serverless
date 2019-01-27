terraform {
  required_version = ">= 0.11.8"
}

provider "aws" {
  region  = "${var.region}"
}

provider "random" {
  version = "= 1.3.1"
}

# access to the list of AWS Availability Zones
data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "OpenFaaS-VPC"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = "OpenFaaS-Demo-Cluster"
  subnets      = ["${module.vpc.private_subnets}"]
  vpc_id       = "${module.vpc.vpc_id}"
  worker_groups = [
    {
      instance_type = "m4.large"
      asg_max_size  = 5
    }
  ]
  tags = {
    environment = "test"
  }
}

