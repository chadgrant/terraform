variable "name" {}
variable "vpc_id" {}
variable "cidrs" {}
variable "azs" {}
variable "nat_network_interface_ids" {}
variable "environment" {}
variable "team" {}
variable "tag_prefix" {}

resource "aws_subnet" "private" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(split(",", var.cidrs), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count             = "${length(split(",", var.cidrs))}"

  tags {
    Name = "${var.name}-${element(split(",", var.azs), count.index)}"
    "${var.tag_prefix}:environment" = "${var.environment}"
    "${var.tag_prefix}:team" = "${var.team}"
  }

  map_public_ip_on_launch = false
}

resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"
  count  = "${length(split(",", var.cidrs))}"

  route {
    cidr_block  = "0.0.0.0/0"
    network_interface_id = "${element(split(",", var.nat_network_interface_ids), count.index)}"
  }

  tags {
    Name = "${var.name}-${element(split(",", var.azs), count.index)}"
    "${var.tag_prefix}:environment" = "${var.environment}"
    "${var.tag_prefix}:team" = "${var.team}"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(split(",", var.cidrs))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

output "subnet_ids" { value = "${join(",", aws_subnet.private.*.id)}" }
output "route_table_ids" { value = "${join(",", aws_route_table.private.*.id)}" }
