resource "aws_iam_policy" "policy" {
  name   = var.user_name
  policy = file("policy.json")
}

resource "aws_iam_group" "group" {
  name = var.group_name
}

resource "aws_iam_group_policy_attachment" "policy-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_group_membership" "team" {
  name = "group-membership-vitalii-orlovskyi"

  users = [
    var.user_name,
  ]

  group = aws_iam_group.group.name
}

resource "aws_security_group" "sec_group" {
  name        = var.sec_group_name
  description = "Access-HTTP-SSH-SSL"

  tags = {
    Name = var.sec_group_name
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
