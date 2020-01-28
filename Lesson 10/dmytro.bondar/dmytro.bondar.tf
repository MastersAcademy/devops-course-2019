provider "aws" {
#  access_key = "XXXXXX"
#  secret_key = "XXXXXX"
  region     = "eu-west-1"
}


resource "aws_key_pair" "tf-keypair" {
  key_name   = "dmytro.bondar-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfgrukjYDTmvTI6HoIK0dVloqmnj3oCVdceo5nwmQxvYyGdLEkkm0CTVXAJv9UMnF6Lfzzy3BlzjXrAxlybJKiKbneKdp5zMGDlv9bUepE25NNjULwcOIzs51FXhVyKPRkkplcbxkcXmOKBOL83Z3OJFBY/aWzUcbg92tGQoykukresmfhE8i9QqYvuXkPdRRcvDQfOnQLwRrHdcNe7tMQhbPiBvsghIC9HZ7I/IUI2uX9ZP8ms+g4/Ruab/i5OcHXmn0dayLdODZXnG5eY0BB4aSqL/M7tRHTdElDeLeRkBScznUH0OH2dwv6cTKU+I8arPBOwGeDq4cax2TgO3obop7VXpvCgx7aZFrdMr246SfK17vgYSQTAZoum/C04KOqXpDZG1ueI3uzTQSnIZCZ3tOGNMK2Gm7k9gtwC/9J2NAueu668rBwpVv7SPApUQBwIP24JjLr9T+dX6PfIGdmYLDyW+mcXIJHAjnQgmymi4LSpYvxYzKYAKgu2tFJ9zU= mrwhite92@mrwhite92-HP-Laptop-15-da0xxx"
}

data "aws_iam_policy_document" "policy-data" {
  statement {
    sid = "666"

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
}

resource "aws_iam_policy" "dmytro-bondar" {
  name   = "dmytro.bondar"
  policy = data.aws_iam_policy_document.policy-data.json
}


resource "aws_iam_group" "group" {
  name = "Dmytro.Bondar-grp"
}

resource "aws_iam_group_policy_attachment" "pol-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.dmytro-bondar.arn
}

resource "aws_iam_group_membership" "team" {
  name = "Dmytro.Bondar-grp-membership"
  users = [
    "Dmytro.Bondar"
  ]
  group = aws_iam_group.group.name
}

resource "aws_security_group" "dmytro-bondar-sgrp" {
  name        = "dmytro-bondar-sgrp"
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
  tags = {
    Name = "dmytro-bondar-sgrp"
  }
}
resource "aws_spot_instance_request" "spot-request" {
  ami           = "ami-02df9ea15c1778c9c"
  spot_price    = "0.04"
  instance_type = "t3.micro"
  key_name		= aws_key_pair.tf-keypair.key_name
  count		= "1"
  spot_type	= "one-time"
  security_groups = [ aws_security_group.dmytro-bondar-sgrp.name ]
  tags = {
    Name = "Dmytro-Bondar-Spot"
  }
}

resource "aws_ecr_repository" "repo" {
  name                 = "dmytro.bondar"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_s3_bucket" "b" {
  bucket = "ma-19-dmytro-bondar"
  acl    = "private"

  tags = {
    Name        = "Dmytro.Bondar bucket"
    Environment = "Dev"
  }
}