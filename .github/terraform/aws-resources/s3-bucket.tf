# # .github/terraform/s3-bucket.tf

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.domain_name
  acl = "public-read"
  policy = data.aws_iam_policy_document.website_policy.json
  force_destroy = true
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket" "www_website_bucket" {
  bucket = "www.${var.domain_name}"
  acl = "public-read"
  force_destroy = true
  website {
    redirect_all_requests_to = var.domain_name
  }
}
