# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.

data "aws_availability_zones" "available" {}

resource "aws_vpc" "simple-tf-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = "${
        map(
            "Name", "simple-tf-eks-node",
            "kubernetes.io/cluster/${var.cluster-name}", "shared",
        )
    }"
}

resource "aws_subnet" "simple-tf-subnet" {
    count = 2

    availability_zone = "${data.aws_availability_zones.available.names[count.indes]}"
    cidr_block        = "10.0.${count.index}.0/24"
    vpc_id            = "${aws_vpc.simple-tf-vpc.id}"

    tags = "${
        map(
            "Name", "simple-tf-eks-node",
            "kubernetes.io/cluster/${var.cluster-name}", "shared",
        )
    }"
}

resource "aws_internet_gateway" "simple-tf-gateway" {
    vpc_id = "${aws_vpc.simple-tf-vpc.id}"

    tags {
        Name = "simple-tf-eks"
    }
}

resource "aws_route_table" "simple-tf-route-table" {
    vpc_id = "${aws_vpc.simple-tf-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.simple-tf-vpc.id}"
    }
}

resource "aws_route_table_association" "simple-tf-route-table-association" {
    count = 2

    subnet_id       = "${aws_subnet.simple-tf-subnet.*.id[count.index]}"
    route_table_id  = "${aws_route_table.simple-tf-route-table.id}"
}