resource "aws_cloudwatch_log_group" "ecs" {
  name = "${var.environment_short_name}-${var.application}/ecs-agent"
}

resource "aws_cloudwatch_log_group" "service" {
  name = "${var.environment_short_name}-${var.application}/service"
}
