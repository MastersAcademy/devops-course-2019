##Credential description

provider "aws" {
#  access_key = "XXXXXX"
#  secret_key = "XXXXXX"
  region     = "eu-west-1"
}

resource "aws_key_pair" "tf-keypair" {
  key_name   = "tf-keypair-serhii-shevchenko"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD5WNtbZ8mN8fDSWOkuwyX53Se+/jMHCbytjYgGV8XyWDISBCeP/7yUJpC9kn+xBVmR2ETUv8+hcKE4MXPXgTyqHmhAgaU15jG4Hib3dJ/pXqncBqJOS1+DCdkq7UrADLmWAD6TERc+Tna7yxSLvGut8ivAQj1Dh/BwKGrjUokh3SRVn1DJj46VVE60eWFkBcQFMqPot4a330HIYe0x9BkxB1W8WXb59YKSBtQ3pHE57zXoIxAancXx9YL/zthWz0guh8/DuDk09LNN1IxMlg63a40WFBOZwK5ch/C5CAtPDym3pIr6R6cHohiNzCZuiUBTwqQoMse3HTeLj8F9g5vz root@admin-ssd"
}

resource "aws_security_group" "example-secgroup" {
  name        = "TF-Secur-group-serhii-shevchenko"
  description = "Allow TLS inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
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
  tags = {
    Name = "allow_all_https_and_ssh"
  }
}

resource "aws_spot_instance_request" "spot-request" {
  ami           = "ami-02df9ea15c1778c9c"
  spot_price    = "0.04"
  instance_type = "t3a.micro"
  key_name	= aws_key_pair.tf-keypair.key_name
  count		= "1"
  spot_type	= "one-time"
  security_groups = [ aws_security_group.example-secgroup.name ]
  tags = {
    Name = "serhii.shevchenko"
  }
}

resource "aws_s3_bucket" "b" {
  bucket = "ma-19-serhii.shevchenko"
  acl    = "private"

  tags = {
    Name        = "ma-19-serhii.shevchenko"
    Environment = "Dev"
  }
}

resource "aws_ecr_repository" "foo" {
  name                 = "serhii.shevchenko"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}