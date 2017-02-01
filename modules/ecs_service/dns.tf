data "aws_route53_zone" "selected" {
  name = "${var.dns_zone}."
}

resource "aws_route53_record" "api" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.dns_prefix}.${var.dns_search}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_alb.main.dns_name}"]
}
