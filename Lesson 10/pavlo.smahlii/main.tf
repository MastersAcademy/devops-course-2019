provider "aws" {
  #access_key = ""
  #secret_key = ""
  region = "eu-west-1"
  profile = "pavlo.smahlii"
}
	#Access key ID - 
	#Secret access key - 

resource "aws_key_pair" "tf-keypair" {
	key_name	= "tf-keypair-pavlo-smahlii"
	public_key	= "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAdCo4+jNkKgteT5+L9piPQXiGtaCGFTyjtnqUYz7X3oph/aeI48W8WG2uDf+xROOoMwKdvqxR704UARh2tEeCcwZPkCWxz7Q2BLpEI0vJvuiH4QB7wj0RLtT1lYYzjtCfxmIBIW8ZRUE/orj980SerjhQwAk3y6ewZ+jZ+LPl0DFMGEmKu8HAm1HJcBbqRexZTZCcmn0kBjNUbOhbNQlrZsnpeYkn+sEEnHzObSyzTj+4Bn0KPEMQR+Y4RyS5eK2Dlbv5jqxiVLbOYFepG8a4TrMzVRwlG2GwTIqcDI8/CsFvUS5ZTOA4zv1rRnjkptH7lTpV5lMSN9OIBiwqwXPH"
}

resource "aws_security_group" "example-secgroup" {
	name 		= "tf-secur-group-pavlo-smahlii"
	description	= "allow in traffic"

	ingress {
		from_port	= 22
		to_port		= 22
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	ingress {
		from_port	= 443
		to_port		= 443
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	ingress {
		from_port	= 80
		to_port		= 80
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	ingress {
		from_port	= 80
		to_port		= 80
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}
		ingress {
		from_port	= 8080
		to_port		= 8080
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	tags 			= {
		Name = "allow-all-http%-and-ssh"
	}
}

resource "aws_spot_instance_request" "spot-request" {
	ami 			= "ami-02df9ea15c1778c9c"
	spot_price		= "0.04"
	instance_type	= "t3a.micro"
	key_name		= aws_key_pair.tf-keypair.key_name
	count			= "1"
	spot_type		= "one-time"
	security_groups = [ aws_security_group.example-secgroup.name ]
	tags = {
    	Name = "pavlo.smahlii"
  }
}

resource "aws_s3_bucket" "b" {
	bucket 			= "ma-19-pavlo.smahlii"
	acl 			= "private"
	tags = {
	Name 			= "ma-19-pavlo.smahlii"
  }
}

resource "aws_ecr_repository" "foo" {
	name 			= "pavlo.smahlii"
	image_tag_mutability = "MUTABLE"

	image_scanning_configuration {
	scan_on_push = true
  }
}
