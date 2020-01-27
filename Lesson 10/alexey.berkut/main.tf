provider "aws" {
	# access_key =
	# secret_key = 
	region = "eu-west-1"
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

resource "aws_iam_policy" "alexey-berkut-policy" {
	name = "alexey.berkut-policy"
	policy = data.aws_iam_policy_document.policy-data.json
}

resource "aws_iam_group" "group" {
	name = "alexey.berkut-grp"
}

resource "aws_iam_group_policy_attachment" "policy-attach" {
	group = aws_iam_group.group.name
	policy_arn = aws_iam_policy.alexey-berkut-policy.arn
}

resource "aws_iam_group_membership" "team" {
	name = "group-membership-alexey-berkut"
	users = [
		"alexey.berkut",
	]
	group = aws_iam_group.group.name
}

resource "aws_security_group" "security_group" {
  name        = "alexey.berkut-sgrp"
  description = "Open 80, 443, 22 ports"

  tags = {
    Name = "alexey.berkut-sgrp"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

	ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_spot_instance_request" "instance" {
	ami = "ami-02df9ea15c1778c9c"
	instance_type = "t3a.micro"
	security_groups = [
		aws_security_group.security_group.name,
	]
	count = "1"
	tags = { Name = "alexey.berkut" }
}

resource "aws_s3_bucket" "bucket" {
	bucket = "ma-19-alexey.berkut"
	acl = "private"
	tags = { Name = "alexey-berkut" }
}

resource "aws_ecr_repository" "ECR" {
	name = "alexey.berkut"
	image_scanning_configuration {
		scan_on_push = "true"
	}
}

