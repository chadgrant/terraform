resource "aws_cloudwatch_log_group" "ecs" {
  name = "${var.name}/ecs-agent"
}

resource "aws_cloudwatch_log_group" "service" {
  name = "${var.name}/service"
}
