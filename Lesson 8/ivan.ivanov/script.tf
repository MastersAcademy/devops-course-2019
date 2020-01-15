##Credential description

provider "aws" {
#  access_key = "XXXXXX"
#  secret_key = "XXXXXX"
  region     = "eu-west-2"
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
}

resource "aws_iam_policy" "almost-admin" {
  name   = "almost-admin-ivan-ivanov"
  policy = data.aws_iam_policy_document.policy-data.json
}


resource "aws_iam_group" "group" {
  name = "Almost-Admin-Ivan-Ivanov"
}

resource "aws_iam_group_policy_attachment" "pol-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.almost-admin.arn
}

resource "aws_iam_user" "user_one" {
  name = "test-user-ivan-ivanov"
}

resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"
  users = [
    aws_iam_user.user_one.name,
  ]
  group = aws_iam_group.group.name
}

resource "aws_key_pair" "tf-keypair" {
  key_name   = "tf-keypair-ivan-ivanov"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVEOo9B2/ldZ8ufNhX8UVDP+HtqdORkPcxPcc2APqdrs6f8h+3eaxVHNuvUVuehlg0NmZKPI1TnHqhZQbOcXUgACWns8kg3d7r82zUIjIpMp6R0jk3JN7h6WYSTgvGW83IFXBTEeKbhV50ZfXyz2XB0e4alHPYxXP2saSMRD8Np6RZ0TnaBihz87C8zz6H8fiq0PGdsgSNz3Lq9eixH97JZmyLLg5b6/stT4knwf4542KLs5zGs34lI8zYaAqTS5bdJ1KC6ykHmhA2OUPoTavWs9bzrSS/VbKsrStWy1FjwKGGArJDHhjVrCH51p40Ix3wFoDbmf7Mazb8ASgSjsAv hexus@devops"
}

resource "aws_security_group" "example-secgroup" {
  name        = "TF-Secur-group-ivan-ivanov"
  description = "Allow TLS inbound traffic"
#  vpc_id      = aws_vpc.main.id

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
    Name = "allow_all_https_and_ssh"
  }
}

resource "aws_spot_instance_request" "spot-request" {
  ami           = "ami-0be057a22c63962cb"
  spot_price    = "0.04"
  instance_type = "t3.micro"
  key_name		= aws_key_pair.tf-keypair.key_name
  count		= "2"
  spot_type	= "one-time"
  security_groups = [ aws_security_group.example-secgroup.name ]
  tags = {
    Name = "Ivan-Ivanov-Spot"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_spot_instance_request.spot-request[1].spot_instance_id
}

resource "aws_ebs_volume" "example" {
  availability_zone = "eu-west-2a"
  size              = 10
}
