resource "aws_ecr_repository" "tf" {
  name                 = "tf_homework"

  image_scanning_configuration {
    scan_on_push = true
  }
}
