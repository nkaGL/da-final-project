resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraformstate-ninagl2022"

    #   lifecycle {
    #       prevent_destroy = true
    #   }
    
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                  sse_algorithm = "AES256"
            }
        }
    }
}
