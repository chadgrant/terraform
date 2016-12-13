variable "aws_region"             {}
variable "environment"            {}
variable "tag_prefix"             {}
variable "environment_short_name" {}
variable "vpc_id"                 {}
variable "vpc_cidr"               {}
variable "vpn_name"               {}
variable "customer_cidrs"         {}
variable "customer_gateway_name"  {}
variable "customer_gateway_ip"    {}

variable "ip_sla_target" {
  description = "ip of pingable target to test SLA (doesn't matter)"
  default="8.8.8.8"
}

resource "aws_vpn_gateway" "vpn_gateway" {
    vpc_id                  = "${var.vpc_id}"
    tags {
        Name                = "${var.environment_short_name}-${var.vpn_name}-vpg"
        "${var.tag_prefix}:environment" = "${var.environment}"
    }
}

resource "aws_customer_gateway" "gateway" {
    type                    = "ipsec.1"
    bgp_asn                 = "${65001 + count.index}"
    ip_address              = "${var.customer_gateway_ip}"
    tags {
        Name                = "${var.environment_short_name}-${var.vpn_name}-cgw"
        ConnectsTo          = "${var.customer_gateway_name}"
        "{var.tag_prefix}:environment" = "${var.environment}"
    }
}

resource "aws_vpn_connection" "vpn" {
    static_routes_only      = true
    type                    = "ipsec.1"
    vpn_gateway_id          = "${aws_vpn_gateway.vpn_gateway.id}"
    customer_gateway_id     = "${aws_customer_gateway.gateway.id}"
    tags {
        Name                = "${var.environment_short_name}-${var.vpn_name}-vpn"
        ConnectsTo          = "${var.customer_gateway_name}"
        "{var.tag_prefix}:environment" = "${var.environment}"
    }
}

resource "aws_vpn_connection_route" "routes" {
    destination_cidr_block  = "${element(split(",", var.customer_cidrs), count.index)}"
    vpn_connection_id       = "${aws_vpn_connection.vpn.id}"
    count                   = "${length(split(",", var.customer_cidrs))}"
}

data "template_file" "remote_acls" {

  template=<<EOF
object network obj-SrcNet subnet ${remote_subnet} ${remote_netmask}
object network obj-amzn subnet ${local_subnet} ${local_netmask}
access-list acl-amzn extended permit ip ${remote_subnet} ${remote_netmask} ${local_subnet} ${local_netmask}
access-list amzn-filter extended permit ip ${local_subnet} ${local_netmask} ${remote_subnet} ${remote_netmask}
EOF
  vars {
    remote_subnet  = "${cidrhost(element(split(",", var.customer_cidrs), count.index), 0)}"
    remote_netmask = "${cidrnetmask(element(split(",", var.customer_cidrs), count.index))}"
  }

  count = "${length(split(",", var.customer_cidrs))}"
}

data "template_file" "config" {
    template                = "${file("${path.module}/cisco-asa.tpl")}"
    vars {
        sla_host_ip         = "${var.ip_sla_target}"
        remote_acls         = "${join("\n", data.template_file.remote_acls.*.rendered)}"
        local_subnet        = "${cidrhost(var.vpc_cidr, 0)}"
        local_netmask       = "${cidrnetmask(var.vpc_cidr)}"
        tunnel1_ip          = "${aws_vpn_connection.vpn.tunnel1_address}"
        tunnel1_key         = "${aws_vpn_connection.vpn.tunnel1_preshared_key}"
        tunnel2_ip          = "${aws_vpn_connection.vpn.tunnel2_address}"
        tunnel2_key         = "${aws_vpn_connection.vpn.tunnel2_preshared_key}"
    }
}

output "gateway_id"     { value = "${aws_vpn_gateway.vpn_gateway.id}" }
output "cisco_template" { value = "${data.template_file.config.rendered}" }
