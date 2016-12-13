variable "name" {}
variable "azs" {}
variable "public_subnet_ids" {}
variable "environment" {}
variable "gateway_id" {} //here to force a dependency on an igw, but not used. modules dont support depends_on yet

//bug in terraform won't let me use the proper count var public_subnet_ids
//https://github.com/hashicorp/terraform/issues/3888
resource "aws_eip" "nat" {
    count = "${length(split(",", var.azs))}" # Comment out count to only have 1 NAT

    vpc   = true
}

resource "aws_nat_gateway" "nat" {
  count         = "${length(split(",", var.azs))}" # Comment out count to only have 1 NAT

  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(split(",",var.public_subnet_ids), count.index)}"
}

output "subnet_ids"            { value = "${join(",", aws_nat_gateway.nat.*.subnet_id)}" }
output "network_interface_ids" { value = "${join(",", aws_nat_gateway.nat.*.network_interface_id)}" }
output "private_ips"           { value = "${join(",", aws_nat_gateway.nat.*.private_ip)}" }
output "public_ips"            { value = "${join(",", aws_nat_gateway.nat.*.public_ip)}" }
