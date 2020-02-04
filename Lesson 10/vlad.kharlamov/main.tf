
variable "access_key" {
type = string
default = "AKIAW5SGOL54UQG3AD7J"
}
#variable "secret_key" {
#type = string
#}

provider "aws" {
  version = "~> 2.0"
  alias = "vlad_kharlamov_homework"
  access_key = var.access_key
#  secret_key = var.secret_key
  region = "eu-west-1"
}

resource "aws_key_pair" "key" {
  key_name   = "vlad.kharlamov"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtRNB0GTa2O3aUDm2XLnYA4mWIKo7fFNQW67Y1MmymC+78tSYG75ykf1tLm0lOsbUmcUjn6eDYOgxCs20PGwH6xHTJu1kZYTLICxzWxwChqodOL3uQUUYYdr27CRLjlxgu6FVXPrWZIaV6Dd42p5rvlTewD7fI9AHk7KapWCSInN2dIIUrT23CL/z/iE9r7FcKQmsTHnRDk5tcwCC87lK5FcfCXkINUrxODbLZlkzavkPPqTcDqup6IVRaWzDCpLq+Jb1vD2KpCWpgN6dJ89ujfMdxsLMedV5O6cts8V4BQ6R1gqL1kY6LB492stZ/nqxjGlAxCuVWFgEhPxXOepnt root@vlad-ubuntu"
}

resource "aws_security_group" "tf_homework" {
  name        = "tf_homework_spot"
  description = "Allow HTTP HTTPS SSH"

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
    Name = "allow_http_https_ssh"
  }
}

resource "aws_spot_instance_request" "spot-request" {
  ami           = "ami-035966e8adab4aaad"
  spot_price    = "0.01"
  instance_type = "t3a.micro"
  key_name	= aws_key_pair.key.key_name
  count		= "1"
  spot_type	= "one-time"
  security_groups = [aws_security_group.tf_homework.name ]
  tags = {
    Name = "vlad.kharlamov.homework"
  }

}
resource "aws_ebs_volume" "tf_homework" {
  availability_zone = "eu-west-1c"
  size              = 5
}

module "s3" {
  source = "./s3"
}
