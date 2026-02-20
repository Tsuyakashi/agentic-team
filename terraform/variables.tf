variable "region" {
  type    = string
  default = "eu-central-1"
}

# VPC

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "av_zone_1" {
  type    = string
  default = "eu-central-1a"
}

variable "av_zone_2" {
  type    = string
  default = "eu-central-1b"
}

variable "all_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

# EC2

variable "instance_type" {
  type = string
  default = "t2.nano"
}

variable "instances_key_name" {
  type = string
  default = "ag-team"
}

# RDS

variable "db_username" {
  type = string
  default = "default"
}

variable "db_password" {
  type = string
  default = "default"
}