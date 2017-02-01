data "aws_security_group" "services" {
  name = "${var.security_group_name}"

  tags{
    "${var.tag_prefix}:environment" = "${var.environment}"
  }
}

resource "aws_db_instance" "api" {
  allocated_storage          = "${var.disk_space_gigs}"
  storage_type               = "gp2"
  engine                     = "mysql"
  engine_version             = "5.7.11"
  auto_minor_version_upgrade = true
  final_snapshot_identifier  = "${var.final_snapshot_identifier}"
  copy_tags_to_snapshot      = true
  instance_class             = "${var.sql_size}"
  identifier                 = "${var.environment_short_name}-${var.db_identifier}"
  name                       = "${var.sql_database}"
  parameter_group_name       = "default.mysql5.7"
  username                   = "${var.sql_username}"
  password                   = "${var.sql_password}"
  port                       = "${var.sql_port}"
  db_subnet_group_name       = "${var.db_subnet_group_name}"
  vpc_security_group_ids     = ["${data.aws_security_group.services.id}"]
  backup_retention_period    = "${var.sql_backup_retention_period}"
  publicly_accessible        = false
  apply_immediately          = "true"

  tags {
    "${var.tag_prefix}:environment"  = "${var.environment}"
    "${var.tag_prefix}:application"  = "${var.application}"
  }
}
