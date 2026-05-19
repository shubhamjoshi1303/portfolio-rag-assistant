data "aws_caller_identity" "current" {}

locals {
  knowledge_base_source_dir = "${path.module}/../knowledge-base"
  knowledge_base_files      = fileset(local.knowledge_base_source_dir, "**/*")
  knowledge_base_bucket_name = lower(
    "${var.project_name}-knowledge-base-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
  )
}

resource "aws_s3_bucket" "knowledge_base" {
  bucket = local.knowledge_base_bucket_name

  tags = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "knowledge_base" {
  bucket = aws_s3_bucket.knowledge_base.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "knowledge_base" {
  bucket = aws_s3_bucket.knowledge_base.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "knowledge_base_documents" {
  for_each = local.knowledge_base_files

  bucket       = aws_s3_bucket.knowledge_base.id
  key          = "${var.knowledge_base_s3_prefix}/${each.value}"
  source       = "${local.knowledge_base_source_dir}/${each.value}"
  content_type = "text/markdown"
  etag         = filemd5("${local.knowledge_base_source_dir}/${each.value}")

  depends_on = [
    aws_s3_bucket_public_access_block.knowledge_base,
    aws_s3_bucket_server_side_encryption_configuration.knowledge_base
  ]
}
