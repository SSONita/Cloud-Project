resource "aws_s3_bucket" "app_bucket" {
  bucket = "student2-cloudproject-123456" # ⚠️ change if error

  tags = {
    Name = "App Storage"
  }
}