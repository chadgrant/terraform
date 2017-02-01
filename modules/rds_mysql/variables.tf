variable "aws_region"                   {}
variable "dns_zone_id"                  {}
variable "dns_search"                   {}
variable "dns_prefix"                   {}
variable "tag_prefix"                   {}
variable "environment_short_name"       {}
variable "environment"                  {}
variable "application"                  {}
variable "final_snapshot_identifier"    {}
variable "disk_space_gigs"              { default = "5" }
variable "db_identifier"                {}
variable "sql_database"                 {}
variable "sql_username"                 {}
variable "sql_password"                 {}
variable "sql_port"                     { default="3306" }
variable "sql_backup_retention_period"  {}
variable "sql_size"                     {}
variable "sql_multi_az"                 {}
variable "security_group_name"          { default = "" }
variable "db_subnet_group_name"         { default = "" }
