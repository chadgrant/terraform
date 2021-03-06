data "template_file" "ecs_service_role" {
  template = "${file("${path.module}/iam/ecs-service-role.json")}"
  vars { }
}

resource "aws_iam_role" "ecs_service" {
  name = "${var.name}-ecs-role"

  assume_role_policy = "${data.template_file.ecs_service_role.rendered}"
}

data "template_file" "ecs_service" {
  template = "${file("${path.module}/iam/ecs-service-policy.json")}"
  vars { }
}

resource "aws_iam_role_policy" "ecs_service" {
  name    = "${var.name}-ecs-policy"
  role    = "${aws_iam_role.ecs_service.name}"
  policy  = "${data.template_file.ecs_service.rendered}"

  provisioner "local-exec" {
    command = "sleep 140" #cheap hack to try and make up for IAM eventual consistency
  }
}






resource "aws_iam_instance_profile" "service" {
  name  = "${var.name}-ecs-instance"
  roles = ["${aws_iam_role.service_instance.name}"]
}

data "template_file" "service_instance" {
  template = "${file("${path.module}/iam/service-instance-role.json")}"
}

resource "aws_iam_role" "service_instance" {
  name = "${var.name}-ecs-instance-role"

  assume_role_policy = "${data.template_file.service_instance.rendered}"
}

data "template_file" "service_instance_profile" {
  template = "${file("${path.module}/iam/service-instance-profile-policy.json")}"

  vars {
    svc_log_group_arn         = "${aws_cloudwatch_log_group.service.arn}"
    ecs_log_group_arn         = "${aws_cloudwatch_log_group.ecs.arn}"
    aws_region                = "${var.aws_region}"
    environment               = "${var.environment}"
    environment_short_name    = "${var.environment_short_name}"
    service                   = "${var.service}"
    bucket                    = "${var.bucket}"
  }
}

resource "aws_iam_role_policy" "instance" {
  name   = "${var.name}-ecs-role"
  role   = "${aws_iam_role.service_instance.name}"
  policy = "${data.template_file.service_instance_profile.rendered}"

  provisioner "local-exec" {
    command = "sleep 140" #cheap hack to try and make up for IAM eventual consistency
  }
}

resource "aws_iam_role_policy" "instance-service" {
  name   = "${var.name}-ecs-service-role"
  role   = "${aws_iam_role.service_instance.name}"
  policy = "${var.service_iam_policy}"

  provisioner "local-exec" {
    command = "sleep 140" #cheap hack to try and make up for IAM eventual consistency
  }
}
