
variable "access_key" {
type = string
default = "AKIAW5SGOL54UQG3AD7J"
}
#variable "secret_key" {
#type = string
#}

provider "aws" {
  alias = "vlad_kharlamov_homework"
  access_key = var.access_key
#  secret_key = var.secret_key
  region = "eu-west-1"
}

resource "aws_key_pair" "key" {
  key_name   = "vlad.kharlamov"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQgQh7GPHnkcGQ5oHi4udUYERRlWJsCiLw8diPVmP0A1bf1LKmOLa3Ly15+Sst8P1lzNsQa23v5zZ7IJumD0dijwOCQYw0Nd/GJZV7NCnx7bn04e9n3OeOIynPsskF/z1EjCJn1ZE0BazA6SeyiETAYet3UhTseaAszg+8tHllYSsY+pyHMHdroE66mAmE56S5Ie6jotKaA/YEqL1KyFWCMkXaTEeca0CTfkLQMhQROgjMn04rVGjkuX7fleJgkyyg2FxXem38FwAPonUlVRDJlpyeeP9f4dw7bdyTxpoMUE+JpG/skGElN+YYsejIyN7KaGB9kszWFxBsFSerxvt3 root@vlad-ubuntu"
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
module "ecr" {
 source = "./ecr"
}
module "task_2" {
 source = "./2nd_task"
}
