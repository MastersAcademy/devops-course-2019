### AWS CREDENTIALS ###
provider "aws" {
  profile = "devops"
  region = "eu-west-1"
}

##########################################################################################

### IAM POLICY AND SECURITY GROUP ###

data "aws_iam_policy_document" "policy-data" {
  statement {
    sid = "21"
    
    actions = [
      "ec2:*"
    ]
    
    resources = [
      "*"
    ]
  }
  
  statement {
    actions = [
      "ecr:*"
    ]
    
    resources = [
      "*"
    ]
  }
  
  statement {
    actions = [
      "s3:*"
    ]
    
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "olha-bezpalchuk" {
  name = "olha.bezpalchuk"
  policy = data.aws_iam_policy_document.policy-data.json
}

resource "aws_iam_group" "group" {
  name = "olha.bezpalchuk-grp"
}

resource "aws_iam_group_policy_attachment" "policy-attachment" {
  group = aws_iam_group.group.name
  policy_arn = aws_iam_policy.olha-bezpalchuk.arn
}

resource "aws_iam_group_membership" "team" {
  name = "olha-bezpalchuk-group-membership"
  users = [
    "olha.bezpalchuk"
  ]
  group = aws_iam_group.group.name
}

resource "aws_security_group" "security-group" {
  name = "olha.bezpalchuk-sgrp"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##########################################################################################

### EC2 SPOT REQUEST ###

resource "aws_key_pair" "tf-keypair" {
  key_name = "tf-keypair-olha-bezpalchuk"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD4V32zctr4k9mYgTp9Nr+TpwTboJK1T9Uib/NP5oJKmeAsHlE9gll/RgtPKCCoL9x8Sdo0hIITQdQzaic6Enxs6/EfymaEb4OSyEgYGOMUcYaOT5u6L7IMLDLYKuLzX7QW1ETSONMrA8wwY4A935qH/vMbihOHnaVIybj7xp2yMuoowEK+303drDKrMx7wc7mr10pB6r/uXqe3jdWuHJo8GggSEe4+X1blJo02s6GG8DIXg4tBiI3GNd/K8Y1b6qJeJqS7hyF6+ApnTUYSsd3OdRCOYHB8GEZetthcBoKX+a6GnRd6mN2IFnhmXnLtFe+2LEQsIWAjVKYqZZoteTqD lekra@zalman"
}

resource "aws_spot_instance_request" "spot" {
  ami = "ami-00035f41c82244dab"
  spot_price = "0.03"
  instance_type = "t3a.micro"
  key_name = aws_key_pair.tf-keypair.key_name
  count = "1"
  spot_type = "one-time"
  security_groups = [ aws_security_group.security-group.name ]
  tags = {
    Name = "olha-bezpalchuk-spot"
  }
}

##########################################################################################

### S3 BUCKET ###

resource "aws_s3_bucket" "bucket" {
  bucket = "ma-19-olha.bezpalchuk"
  acl = "private"

  tags = {
    Name = "ma-19-olha.bezpalchuk"
  }
}

##########################################################################################

### ECR REPOSITORY ###

resource "aws_ecr_repository" "repository" {
  name = "olha.bezpalchuk"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
