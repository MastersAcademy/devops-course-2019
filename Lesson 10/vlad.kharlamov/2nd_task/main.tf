data "aws_iam_policy_document" "policy-ec2-s3-ecr" {

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
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::*",
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

resource "aws_iam_policy" "policy" {
  name        = "vlad.kharlamov"
  description = "Vlad Kharlamov policy"
  policy      = data.aws_iam_policy_document.policy-ec2-s3-ecr.json
}

resource "aws_iam_group" "group" {
  name = "vlad.kharlamov-grp"
}

resource "aws_iam_group_policy_attachment" "attach-policy" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_group_membership" "membership" {
  name = "vlad.kharlamov-grp-membership"
  users = [
    "server_homework"
  ]
  group = aws_iam_group.group.name
}
