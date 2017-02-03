resource "aws_alb_target_group" "service" {
  name     = "${var.name}"
  port     = "${var.host_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  deregistration_delay = 60

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    path                = "${var.healthcheck_url}"
    interval            = 10
  }
}

resource "aws_alb" "main" {
  name            = "${var.name}"
  subnets         = ["${split(",", var.public_subnets)}"]
  security_groups = ["${split(",", var.public_security_groups)}"]

  access_logs {
    bucket = "${var.bucket}"
    prefix = "logs/${var.service}"
  }

  tags {
    "${var.tag_prefix}:environment"  = "${var.environment}"
    "${var.tag_prefix}:service"      = "${var.service}"
    "${var.tag_prefix}:team"         = "${var.team}"
  }
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "${var.ssl_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.service.id}"
    type             = "forward"
  }
}
