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

module "resources" {
  source = "./resources"
}