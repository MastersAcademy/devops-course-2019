provider "aws" {
access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region      = "eu-west-1"
}

resource "aws_iam_policy" "policy" {
  name   = "policy-kolya-stelmax"
  policy = file("policy.json")
}


resource "aws_iam_group" "group" {
  name = "kolya-stelmax-group"
}

resource "aws_iam_group_policy_attachment" "policy-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_user" "user" {
  name = "user-kolya-stelmax"
}

resource "aws_iam_group_membership" "team" {
  name = "group-membership-kolya-stelmax"
  users = [
    aws_iam_user.user.name,
  ]
  group = aws_iam_group.group.name
}

resource "aws_security_group" "kolya-stelmax-sgrp" {
  name            = "group-kolya-Stelmax"
  description     = "kolya Stelmax"

  ingress {
    from_port     = 443
    to_port       = 443
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    from_port     = 22
    to_port       = 22
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }
  ingress {
    from_port     = 8080
    to_port       = 8080
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }
}

resource "aws_spot_instance_request" "spot-request" {
  ami             = "ami-02df9ea15c1778c9c"
  spot_price      = "0.04"
  instance_type   = "t3a.micro"
  count           = "1"
  spot_type       = "one-time"
  security_groups = [aws_security_group.kolya-stelmax-sgrp.name]
  tags            = {
    Name          = "kolya-Stelmax"
  }
}

resource "aws_s3_bucket" "buc" {
  bucket          = "ma-19-kolya-stelmax"
  acl             = "private"

  tags = {
    Name          = "Kolya.Stelmax"
    Environment   = "Dev"
  }
}

resource "aws_ecr_repository" "ECR" {
  name            = "kolya.stelmax"
  image_scanning_configuration {
    scan_on_push   = true
  }
}
