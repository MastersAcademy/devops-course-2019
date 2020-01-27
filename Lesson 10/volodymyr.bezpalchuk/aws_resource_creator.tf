##Credential description

provider "aws" {
  # access_key = "XXXXXXXXXX"
  # secret_key = "XXXXXXXXXX"
  region     = "eu-west-1"
}


data "aws_iam_policy_document" "policy-data" {
  statement {
    sid = "1"

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

resource "aws_iam_policy" "admin-policy" {
  name   = "volodymyr.bezpalchuk"
  policy = data.aws_iam_policy_document.policy-data.json
}

resource "aws_iam_group" "group" {
  name = "volodymyr.bezpalchuk-grp"
}

resource "aws_iam_group_policy_attachment" "pol-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.admin-policy.arn
}

resource "aws_iam_group_membership" "team" {
  name  = "volodymyr-bezpalchuk-group-membership"
  users = [
    "volodymyr.bezpalchuk",
  ]
  group = aws_iam_group.group.name
}

resource "aws_key_pair" "tf-keypair" {
  key_name   = "tf-keypair-volodymyr-bezpalchuk"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6RP5l9C3EF02efjqAA8oMNc4yb6v9qDuxS+2d2nq4V31omqi8zGGYdw65VBe2Yc5Igr+rAzXOK34IIU/285hYoq9vWaVWDHywasn/hy97DKOhK4AVguz+R+ZuXIKPDPWzWmzBMd0xLBL/UmOUXBDaGVQTuAPpAXnF+e6utMgNLrRWlfZhVFTOfbEI0S6tnQJWigKNQ46PpOnR4sIp5giyXpTBexM59AVVxFr5n0xEHDGJp8IKufSj5INwNrFgYPAfAaVykTODsXoC+Z5qMXExUrE477sbaTesnmmpHDKlXLZ3yEfUx+zLs7CHRPzD9PC5pAx3Bddhfr6PE7TcWXu3w+o5bqFW9U9N2F7GbR8sx4E+FH0f/yONtz5nVovatXbPh/5vrswu97U5s5JSLglYSwzPg9sccsXTFd7qAYaxRpVPBaF9VRpua5WNKaNF8OMHJ7QlXDs0jkmPjx3y9rDJtdj5ip970DZBaQuHFvb4D7wW+s7YwY40pxw5ItaXJp/kE+XgU5Q/rPn1Dq13oB/hcIO6Uqh+1zIOLcoyaYlzPa9dZUr3sfKqCZsu+fgPW5gt9aU06gRwIKmasOvxLOJyPuX8GJDwklOFXLawOINwv7PQsaWIXQUbqUx88F6OF/X0X2Q7yWTL8UFj5ESxm2Kf/vsaoMFslrbuGWEuLbTz4Q== bezpalchukv@gmail.com"
}

resource "aws_security_group" "security-group" {
  name        = "volodymyr.bezpalchuk-sgrp"
  description = "Allow inbound traffic"

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
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "volodymyr.bezpalchuk-sgrp"
  }
}

resource "aws_spot_instance_request" "spot-request" {
  ami           = "ami-02df9ea15c1778c9c"
  spot_price    = "0.04"
  instance_type = "t3.micro"
  key_name		= aws_key_pair.tf-keypair.key_name
  count		= "1"
  spot_type	= "one-time"
  security_groups = [ aws_security_group.security-group.name ]
  tags = {
    Name = "volodymyr.bezpalchuk"
  }
}

resource "aws_ecr_repository" "aws_repo" {
  name = "volodymyr.bezpalchuk"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_s3_bucket" "aws_bucket" {
  bucket = "ma-19-volodymyr.bezpalchuk"
  acl    = "private"

  tags = {
    Name        = "volodymyr-bezpalchuk-bucket"
    Environment = "Dev"
  }
}
