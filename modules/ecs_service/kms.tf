data "template_file" "kms_policy" {
  template = "${file("${path.module}/iam/kms-policy.json")}"

  vars {
    aws_account       = "${var.aws_account}"
    instance_role_arn = "${aws_iam_role.service_instance.arn}"
  }
}

resource "aws_kms_key" "config" {
    description = "used for decrypting configuration information stored in S3"
    deletion_window_in_days = 7
    policy="${data.template_file.kms_policy.rendered}"

    //making this depend on the asg since there are weird race conditions going on
    depends_on = ["aws_autoscaling_group.service"]
}

resource "aws_kms_alias" "alias" {
    name_prefix = "alias/${var.environment_short_name}-${var.application}"
    target_key_id = "${aws_kms_key.config.key_id}"
}

resource "aws_s3_bucket_object" "service_bucket" {
  key        = "services/${var.application}/config.env"
  bucket     = "${var.bucket}"
  content    = "${var.application_vars}"
  kms_key_id = "${aws_kms_key.config.arn}"
}
