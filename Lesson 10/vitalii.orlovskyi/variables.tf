variable "aws_region" {
  description = "AWS_REGION"
  default     = "eu-west-1"
}

variable "aws_access_key" {
  description = "AWS_ACCESS_KEY"
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS_SECRET_KEY"
  default     = ""
}

variable "user_name" {
  default = "vitalii.orlovskyi"
}

variable "group_name" {
  default = "vitalii.orlovskyi-grp"
}

variable "sec_group_name" {
  default = "vitalii.orlovskyi-sgrp"
}
