# Create the bucket
resource "aws_s3_bucket" "Bucket_Name" {
  bucket = "Bucket_Name"
}

# The Guardrail: Explicitly block all public access configurations
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.secure_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}