resource "aws_ecs_cluster" "main" {
  name = "${var.name}"
}

resource "aws_ecs_service" "service" {
  name            = "${var.name}"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  desired_count   = "${var.task_count}"
  iam_role        = "${aws_iam_role.ecs_service.name}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.service.id}"
    container_name   = "${var.service}"
    container_port   = "${var.container_port}"
  }

  depends_on = [
    "aws_iam_role_policy.ecs_service",
    "aws_iam_role_policy.instance",
    "aws_alb_listener.front_end",
    "aws_autoscaling_group.service"
  ]
}

output "autoscaling_group_name" { value = "${aws_autoscaling_group.service.name}" }
