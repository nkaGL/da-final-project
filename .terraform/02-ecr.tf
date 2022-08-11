# Elastic Container Registry
resource "aws_ecr_repository" "projectdev-ecr" {
  name = "webapp"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}

# Push Docker Image
