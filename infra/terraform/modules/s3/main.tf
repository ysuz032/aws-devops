resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name        = "Name"
    Environment = var.bucket_name
  }
}