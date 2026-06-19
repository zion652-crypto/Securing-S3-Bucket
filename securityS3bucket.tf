provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "Bucket_Name" {
  bucket = "company-secure-bucket-2026"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.Bucket_Name.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "logging" {
  bucket        = aws_s3_bucket.Bucket_Name.id
  target_bucket = aws_s3_bucket.Bucket_Name.id 
  target_prefix = "security-logs/"
}

resource "aws_kms_key" "my_vault_key" {
  description             = "Strict KMS key for S3 encryption"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.Bucket_Name.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.my_vault_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.Bucket_Name.id
  rule {
    id     = "archive-old-data"
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA" 
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket                  = aws_s3_bucket.Bucket_Name.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
