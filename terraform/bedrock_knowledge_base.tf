data "aws_partition" "current" {}

locals {
  titan_embeddings_model_arn = "arn:${data.aws_partition.current.partition}:bedrock:${var.aws_region}::foundation-model/amazon.titan-embed-text-v2:0"
  s3vectors_bucket_name      = lower("${var.project_name}-kb-vectors-${data.aws_caller_identity.current.account_id}-${var.aws_region}")
  s3vectors_index_name       = "${var.project_name}-kb-index"
}

resource "aws_iam_role" "bedrock_knowledge_base" {
  name = "${var.project_name}-bedrock-kb-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:${data.aws_partition.current.partition}:bedrock:${var.aws_region}:${data.aws_caller_identity.current.account_id}:knowledge-base/*"
          }
        }
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy" "bedrock_knowledge_base" {
  name = "${var.project_name}-bedrock-kb-policy"
  role = aws_iam_role.bedrock_knowledge_base.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "InvokeTitanEmbeddings"
        Action = [
          "bedrock:InvokeModel"
        ]
        Effect = "Allow"
        Resource = [
          local.titan_embeddings_model_arn
        ]
      },
      {
        Sid = "ReadKnowledgeBaseSourceBucket"
        Action = [
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.knowledge_base.arn
        Condition = {
          StringLike = {
            "s3:prefix" = [
              var.knowledge_base_s3_prefix,
              "${var.knowledge_base_s3_prefix}/*"
            ]
          }
        }
      },
      {
        Sid = "ReadKnowledgeBaseSourceObjects"
        Action = [
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.knowledge_base.arn}/${var.knowledge_base_s3_prefix}/*"
      },
      {
        Sid = "ReadAndWriteS3Vectors"
        Action = [
          "s3vectors:DeleteVectors",
          "s3vectors:GetIndex",
          "s3vectors:GetVectors",
          "s3vectors:ListIndexes",
          "s3vectors:PutVectors",
          "s3vectors:QueryVectors"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3vectors_vector_bucket.knowledge_base.vector_bucket_arn,
          aws_s3vectors_index.knowledge_base.index_arn
        ]
      }
    ]
  })
}

resource "aws_s3vectors_vector_bucket" "knowledge_base" {
  vector_bucket_name = local.s3vectors_bucket_name

  tags = local.common_tags
}

resource "aws_s3vectors_index" "knowledge_base" {
  index_name         = local.s3vectors_index_name
  vector_bucket_name = aws_s3vectors_vector_bucket.knowledge_base.vector_bucket_name

  data_type       = "float32"
  dimension       = 1024
  distance_metric = "cosine"

  # S3 Vectors has a small limit for filterable metadata. Bedrock stores the
  # document text and internal metadata on each vector, so keep those fields
  # non-filterable and reserve filterable metadata for compact attributes only.
  metadata_configuration {
    non_filterable_metadata_keys = [
      "AMAZON_BEDROCK_METADATA",
      "AMAZON_BEDROCK_TEXT"
    ]
  }

  tags = local.common_tags
}

resource "aws_s3vectors_vector_bucket_policy" "knowledge_base" {
  vector_bucket_arn = aws_s3vectors_vector_bucket.knowledge_base.vector_bucket_arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowBedrockKnowledgeBaseRoleVectorAccess"
        Principal = {
          AWS = aws_iam_role.bedrock_knowledge_base.arn
        }
        Action = [
          "s3vectors:DeleteVectors",
          "s3vectors:GetIndex",
          "s3vectors:GetVectors",
          "s3vectors:ListIndexes",
          "s3vectors:PutVectors",
          "s3vectors:QueryVectors"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3vectors_vector_bucket.knowledge_base.vector_bucket_arn,
          aws_s3vectors_index.knowledge_base.index_arn
        ]
      }
    ]
  })
}

resource "aws_bedrockagent_knowledge_base" "portfolio" {
  name     = "${var.project_name}-kb"
  role_arn = aws_iam_role.bedrock_knowledge_base.arn

  knowledge_base_configuration {
    type = "VECTOR"

    vector_knowledge_base_configuration {
      embedding_model_arn = local.titan_embeddings_model_arn
    }
  }

  storage_configuration {
    type = "S3_VECTORS"

    s3_vectors_configuration {
      index_arn = aws_s3vectors_index.knowledge_base.index_arn
    }
  }

  tags = local.common_tags

  depends_on = [
    aws_iam_role_policy.bedrock_knowledge_base,
    aws_s3vectors_vector_bucket_policy.knowledge_base
  ]
}

resource "aws_bedrockagent_data_source" "s3_documents" {
  knowledge_base_id    = aws_bedrockagent_knowledge_base.portfolio.id
  name                 = "${var.project_name}-s3-documents"
  description          = "Portfolio knowledge-base markdown documents stored in S3."
  data_deletion_policy = "RETAIN"

  data_source_configuration {
    type = "S3"

    s3_configuration {
      bucket_arn = aws_s3_bucket.knowledge_base.arn
      inclusion_prefixes = [
        "${var.knowledge_base_s3_prefix}/"
      ]
    }
  }

  vector_ingestion_configuration {
    # Conservative fixed chunks keep per-vector metadata small enough for S3
    # Vectors while preserving useful context for short markdown portfolio docs.
    chunking_configuration {
      chunking_strategy = "FIXED_SIZE"

      fixed_size_chunking_configuration {
        max_tokens         = 300
        overlap_percentage = 10
      }
    }
  }
}
