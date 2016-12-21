variable "name" {}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "subnet_id" {}
variable "key_name" {}
variable "key_file" {}
variable "region" {}
variable "instance_type" {}
variable "admin_user" {}
variable "admin_pw" {}
variable "license" {}
variable "vpn_cidr" {}
variable "hostname" {}
variable "dns_zone_id" {}
variable "environment" {}
variable "tag_prefix" {}

#warning! these change VERY often
variable "openvpn_amis" {
    default = {
        "us-east-1" = "ami-1a942472"
        "us-west-2" = "ami-47965927" #2.0.24 hvm
    }
}

resource "aws_security_group" "openvpn" {
  name   = "${var.name}"
  vpc_id = "${var.vpc_id}"
  description = "OpenVPN security group"

  tags {
    Name = "${var.name}"
    "${var.tag_prefix}:environment" = "${var.environment}"
  }

  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # For OpenVPN Client Web Server & Admin Web UI
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "udp"
    from_port   = 1194
    to_port     = 1194
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "openvpn" {
  ami           = "${lookup(var.openvpn_amis, var.region)}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  subnet_id     = "${var.subnet_id}"

  vpc_security_group_ids = ["${aws_security_group.openvpn.id}"]

  tags {
    Name = "${var.name}"
    "${var.tag_prefix}:environment" = "${var.environment}"
  }

  # `admin_user` and `admin_pw` need to be passed in to the appliance through `user_data`, see docs -->
  # https://docs.openvpn.net/how-to-tutorialsguides/virtual-platforms/amazon-ec2-appliance-ami-quick-start-guide/
  user_data = <<USERDATA
admin_user=${var.admin_user}
admin_pw=${var.admin_pw}
public_hostname=${var.hostname}
license=${var.license}
USERDATA
}

resource "aws_route53_record" "openvpn" {
  zone_id = "${var.dns_zone_id}"
  name    = "${var.hostname}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.openvpn.public_ip}"]
}

output "private_ip"        { value = "${aws_instance.openvpn.private_ip}" }
output "public_ip"         { value = "${aws_instance.openvpn.public_ip}" }
output "security_group_id" { value = "${aws_security_group.openvpn.id}" }
