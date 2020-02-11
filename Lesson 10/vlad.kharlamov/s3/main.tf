resource "aws_s3_bucket" "bucket" {
  bucket = "vlad.kharlamov.tf.bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
  }
}
