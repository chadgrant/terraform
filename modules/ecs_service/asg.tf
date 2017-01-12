data "aws_security_group" "services" {
  name = "02-${var.environment_short_name}-*"

  tags{
    "${var.tag_prefix}:environment" = "${var.environment}"
  }
}

data "aws_subnet" "privates" {
  availability_zone = "${element(split(",", var.aws_availability_zones), count.index)}"
  vpc_id            = "${data.aws_vpc.current.id}"
  state             = "available"

  tags {
    "Name" = "${var.environment_short_name}-private-${element(split(",", var.aws_availability_zones), count.index)}"
  }

  count = "${length(split(",", var.aws_availability_zones))}"
}

resource "aws_autoscaling_group" "service" {
  name                  = "${var.environment_short_name}-${var.application}"

  availability_zones    = ["${split(",", var.aws_availability_zones)}"]
  vpc_zone_identifier   = ["${data.aws_subnet.privates.*.id}"]

  min_size             = "${var.asg_min}"
  max_size             = "${var.asg_max}"
  desired_capacity     = "${var.asg_desired}"
  launch_configuration = "${aws_launch_configuration.service.name}"

  tag {
    key = "Name"
    value = "ecs-${var.environment_short_name}-${var.application}"
    propagate_at_launch = true
  }
  tag {
    key = "${var.tag_prefix}:application"
    value = "${var.application}"
    propagate_at_launch = true
  }
  tag {
    key = "${var.tag_prefix}:environment"
    value = "${var.environment}"
    propagate_at_launch = true
  }
}

data "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud-config.yml")}"

  vars {
    aws_region            = "${var.aws_region}"
    ecs_cluster_name      = "${aws_ecs_cluster.main.name}"
    ecs_log_level         = "info"
    ecs_agent_version     = "latest"
    ecs_log_group_name    = "${aws_cloudwatch_log_group.ecs.name}"
    dockerhub_username    = "${var.dockerhub_username}"
    dockerhub_password    = "${var.dockerhub_password}"
    dockerhub_email       = "${var.dockerhub_email}"
  }
}

data "aws_ami" "stable_coreos" {
  most_recent = true

  filter {
    name   = "description"
    values = ["CoreOS stable *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["595879546273"] # CoreOS
}

resource "aws_launch_configuration" "service" {
  image_id                    = "${data.aws_ami.stable_coreos.id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.service.name}"
  user_data                   = "${data.template_file.cloud_config.rendered}"
  associate_public_ip_address = false
  name_prefix                 = "${var.environment_short_name}-${var.application}-"

  key_name             = "${var.aws_key_name}"
  security_groups      = ["${data.aws_security_group.services.id}"]

  lifecycle {
    create_before_destroy = true
  }
}
