resource "aws_autoscaling_notification" "asg_notifications" {
  group_names = [
    "${var.autoscaling_group_name}"
  ]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
  topic_arn = "${aws_sns_topic.asg_notifications.arn}"
}

resource "aws_sns_topic" "asg_notifications" {
  name = "${var.name}-asg-notifications"
}

data "template_file" "sns_slack_role" {
  template = "${file("${path.module}/iam/lambda-role.json")}"
}

resource "aws_iam_role" "sns_slack" {
    name = "${var.name}-sns-asg-slack"
    assume_role_policy = "${data.template_file.sns_slack_role.rendered}"
}

resource "aws_lambda_function" "sns_autoscaling_slack" {
    description       = "Processes autoscaling notifications and forwards them to slack channels"
    filename          = "${path.module}/sns-autoscaling-slack.zip"
    source_code_hash  = "${base64sha256(file("${path.module}/sns-autoscaling-slack.zip"))}"
    function_name     = "${var.name}-sns-asg-slack"
    role              = "${aws_iam_role.sns_slack.arn}"
    runtime           = "nodejs4.3"
    handler           = "index.handler"

    environment {
      variables {
        environment_short_name            = "${var.environment_short_name}"
        notification_slack_channel        = "${var.notification_slack_channel}"
        notification_slack_channel_debug  = "${var.notification_slack_channel_debug}"
        notification_slack_hook           = "${var.notification_slack_hook}"
        service                           = "${var.service}"
      }
    }
}

resource "aws_sns_topic_subscription" "auto_scaling" {
    topic_arn = "${aws_sns_topic.asg_notifications.arn}"
    protocol  = "lambda"
    endpoint  = "${aws_lambda_function.sns_autoscaling_slack.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_autoscaling_scale" {
    source_arn    = "${aws_sns_topic.asg_notifications.arn}"
    statement_id  = "AllowScalingEventAlarmsExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.sns_autoscaling_slack.arn}"
    principal     = "sns.amazonaws.com"
}
