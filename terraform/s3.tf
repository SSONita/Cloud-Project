// create storage container
resource "aws_s3_bucket" "profile_bucket" {
  bucket = "auth-profile-bucket"  
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.profile_bucket.id

  block_public_acls   = true
  block_public_policy = true
}