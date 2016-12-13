resource "aws_route53_record" "api" {
  zone_id = "${var.dns_zone_id}"
  name    = "${var.dns_prefix}.db.${var.dns_search}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_db_instance.api.address}"]
}
