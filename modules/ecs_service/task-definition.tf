resource "aws_ecs_task_definition" "task" {
  family                = "${var.environment_short_name}-${var.application}"
  container_definitions = "${var.container_definitions}"
}
