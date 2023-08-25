// Use the account name in the S3 bucket name, because buckets must be globally unique
data "aws_caller_identity" "current" {}
resource "aws_s3_bucket" "site_bucket" {
  bucket = "fft-assignment-files-${data.aws_caller_identity.current.account_id}"
}

// A policy that allows our CloudFront distribution to read files from this bucket
data "aws_iam_policy_document" "site_bucket_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = ["${aws_s3_bucket.site_bucket.arn}/*", aws_s3_bucket.site_bucket.arn]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cloudfront.arn]
    }
  }
}

// Apply the policy above to the bucket
resource "aws_s3_bucket_policy" "site_bucket_policy" {
  bucket = aws_s3_bucket.site_bucket.id
  policy = data.aws_iam_policy_document.site_bucket_policy.json
}
