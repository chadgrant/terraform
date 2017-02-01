resource "aws_ecs_task_definition" "task" {
  family                = "${var.name}"
  container_definitions = "${var.container_definitions}"
}
