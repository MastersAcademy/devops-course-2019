##Credential description

variable "access_key_id" {
  type = string
}

variable "secret_access_key" {
  type = string
}

provider "aws" {
  access_key = var.access_key_id
  secret_key = var.secret_access_key
  region     = "eu-west-1"
}


data "aws_iam_policy_document" "policy-data" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "ec2:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ecr:*",
    ]

    resources = [
      "*",
    ]
  }
}


resource "aws_iam_policy" "vladyslav-volkov" {
  name   = "vladyslav-volkov"
  policy = data.aws_iam_policy_document.policy-data.json
}

resource "aws_iam_group" "group" {
  name = "vladyslav.volkov-grp"
}

resource "aws_iam_group_policy_attachment" "pol-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.vladyslav-volkov.arn
}

resource "aws_iam_group_membership" "team" {
  name = "vladyslav.volkov-grp-membership"
  users = [
    "vladyslav.volkov"
  ]
  group = aws_iam_group.group.name
}

resource "aws_key_pair" "tf-keypair" {
  key_name   = "tf-keypair-vladyslav.volkov"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCOoDYt5FzeD/YtkPxVmjsGWd7qdj7IyHEVd+f44D8xBdvH4fYpadqbrrVOQA6GGAkCaSwUIDeJ0uYChRJJqUaVbYRL14MCfiyaSYl42gSLnwSav2w26f3lgsWeCQUzGTBP6gnePXRd3xu5ERPL+EADlkd0VZV3Ebv7kKtyhQtsUxBBaAE6avj76Dj9eCQgEO1H+HheO7sdRMXJSiyx43sPAJLFyRb2ZczXVYVXXMJkRy8dqpXdDpYfcAcjj3VwYeXfzkSXmZC4f026BJfF7lo9e69p/xwBBTkY96EHGnvbOmtqzBuBC+EsGUPa97I+xsY4bCfUYl+p3j+Veo+MdDr vlad@vlad-Virtual-Machine"
}

resource "aws_security_group" "vladyslav-volkov-sgrp" {
  name        = "vladyslav-volkov-sgrp"
  description = "Allow TLS inbound traffic"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_https_and_ssh"
  }
}

resource "aws_spot_instance_request" "spot-request" {
  ami           = "ami-02df9ea15c1778c9c"
  spot_price    = "0.04"
  instance_type = "t3a.micro"
  key_name 	= aws_key_pair.tf-keypair.key_name
  count		= "1"
  spot_type	= "one-time"
  security_groups = [ aws_security_group.vladyslav-volkov-sgrp.name ]
  tags = {
    Name = "vladyslav.volkov"
  }
}

resource "aws_ecr_repository" "repo" {
  name                 = "vladyslav.volkov"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "ma-19-vladyslav.volkov"
  acl    = "private"

  tags = {
    Name        = "vladyslav.volkov bucket"
    Environment = "Test"
  }
}