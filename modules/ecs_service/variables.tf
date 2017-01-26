variable "aws_key_name"           {}
variable "aws_account"            {}
variable "aws_region"             {}
variable "aws_availability_zones" {}
variable "tag_prefix"             {}
variable "vpc_cidr"               {}
variable "dns_zone_id"            {}
variable "dns_search"             {}
variable "ssl_arn"                {}
variable "environment_short_name" {}
variable "environment"            {}
variable "application"            {}
variable "bucket"                 {}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "2"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "3"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "2"
}

variable "task_count" {
  description = "Desired number of containers running (Should be same as asg_desired)"
  default = "2"
}

variable "healthcheck_url"    {
  default = "/health/asg"
}

variable "dockerhub_username"    {}
variable "dockerhub_email"       {}
variable "dockerhub_password"    {}
variable "docker_image"          {}
variable "container_port"        {}
variable "host_port"             {}
variable "dns_prefix"            {}
variable "container_definitions" { default="" }
variable "application_vars"      { default="" }
variable "service_iam_policy"    {}

variable "public_security_group"   {}
variable "services_security_group" {}
