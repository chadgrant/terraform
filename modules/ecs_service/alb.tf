data "aws_vpc" "current" {

  cidr_block = "${var.vpc_cidr}"

  state="available"

  tags{
    "${var.tag_prefix}:environment" = "${var.environment}"
  }
}

data "aws_security_group" "public" {
  name = "01-${var.environment_short_name}-*"

  vpc_id = "${data.aws_vpc.current.id}"

  tags{
    "${var.tag_prefix}:environment" = "${var.environment}"
  }
}

data "aws_subnet" "publics" {
  availability_zone = "${element(split(",", var.aws_availability_zones), count.index)}"
  vpc_id            = "${data.aws_vpc.current.id}"
  state             = "available"

  tags {
    "Name" = "*-public-${element(split(",", var.aws_availability_zones), count.index)}"
    "${var.tag_prefix}:environment" = "${var.environment}"
  }

  count = "${length(split(",", var.aws_availability_zones))}"
}


resource "aws_alb_target_group" "service" {
  name     = "${var.environment_short_name}-${var.application}"
  port     = "${var.host_port}"
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.current.id}"

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
  name            = "${var.environment_short_name}-${var.application}"
  subnets         = ["${data.aws_subnet.publics.*.id}"]
  security_groups = ["${data.aws_security_group.public.id}"]

  access_logs {
    bucket="${var.bucket}"
    prefix="logs/${var.application}"
  }

  tags {
    "${var.tag_prefix}:environment"  = "${var.environment}"
    "${var.tag_prefix}:application"  = "${var.application}"
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
