# Rails
resource "aws_ecr_repository" "rails-portfolio" {
  name                 = "rails-portfolio"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

# Nginx
resource "aws_ecr_repository" "nginx-portfolio" {
  name                 = "nginx-portfolio"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}