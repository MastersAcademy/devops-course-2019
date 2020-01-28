resource "aws_spot_instance_request" "ec2-spot" {
  ami           = "ami-02df9ea15c1778c9c"
  instance_type = "t3a.micro"

  tags = {
    Name = var.user_name
  }
}

resource "aws_s3_bucket" "s3-bucket" {
  bucket = "ma-19-${var.user_name}"
}

resource "aws_ecr_repository" "ecr-container" {
  name = var.user_name
}

