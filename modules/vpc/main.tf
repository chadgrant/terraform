variable "name"         {}
variable "cidr"         {}
variable "environment"  {}
variable "tag_prefix"   {}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.name}"

    "${var.tag_prefix}:environment" = "${var.environment}"
  }
}

output "vpc_id"   { value = "${aws_vpc.vpc.id}" }
output "vpc_cidr" { value = "${aws_vpc.vpc.cidr_block}" }
output "default_security_group_id" { value = "${aws_vpc.vpc.default_security_group_id}" }
