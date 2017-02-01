variable "aws_key_name"           {}
variable "aws_account"            {}
variable "aws_region"             {}
variable "aws_availability_zones" {}
variable "tag_prefix"             { default = "tag" }
variable "vpc_id"                 {}
variable "dns_zone"               {}
variable "dns_search"             {}
variable "ssl_arn"                {}
variable "environment_short_name" {}
variable "environment"            {}
variable "service"                {}
variable "team"                   {}
variable "bucket"                 {}

variable "name"                   {}

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
  description = "Desired number of containers running"
  default = "2"
}

variable "healthcheck_url"          { default = "/health/asg" }
variable "dockerhub_username"       {}
variable "dockerhub_email"          {}
variable "dockerhub_password"       {}
variable "docker_image"             {}
variable "container_port"           { default="8080" }
variable "host_port"                { default="80"   }
variable "dns_prefix"               {}
variable "container_definitions"    { default=""     }
variable "service_vars"             { default=""     }
variable "service_iam_policy"       {}
variable "public_security_groups"   {}
variable "private_security_groups"  {}
variable "public_subnets"           {}
variable "private_subnets"          {}
