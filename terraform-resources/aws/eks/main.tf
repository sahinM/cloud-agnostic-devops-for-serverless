module "module" {
  source  = "WesleyCharlesBlake/eks/aws"
  version = "1.0.5"

  cluster-name       = "${var.cluster-name}"
  aws-region         = "${var.aws-region}"
  k8s-version        = "${var.k8s-version}"
  node-instance-type = "${var.node-instance-type}"
  desired-capacity   = "${var.desired-capacity}"
  max-size           = "${var.max-size}"
  min-size           = "${var.min-size}"
  vpc-subnet-cidr    = "${var.vpc-subnet-cidr}"
}