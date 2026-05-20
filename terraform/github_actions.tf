data "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}

locals {
  github_actions_role_name = "${var.project_name}-github-actions"
  github_actions_repo_sub  = "repo:shubhamjoshi1303/portfolio-rag-assistant:ref:refs/heads/main"
  terraform_state_key      = "portfolio-rag-assistant/terraform.tfstate"
}

resource "aws_iam_role" "github_actions" {
  name = local.github_actions_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github_actions.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = local.github_actions_repo_sub
          }
        }
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy" "github_actions" {
  # The v2 name intentionally forces replacement of the old inline policy so
  # GitHub Actions does not keep assuming a stale policy document during refresh.
  name = "${var.project_name}-github-actions-policy-v2"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "TerraformStateBucketAccess"
        Action = [
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = "arn:${data.aws_partition.current.partition}:s3:::shubham-terraform-state-cloud"
        Condition = {
          StringLike = {
            "s3:prefix" = [
              local.terraform_state_key,
              "${local.terraform_state_key}*"
            ]
          }
        }
      },
      {
        Sid = "TerraformStateObjectAccess"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Effect = "Allow"
        Resource = [
          "arn:${data.aws_partition.current.partition}:s3:::shubham-terraform-state-cloud/${local.terraform_state_key}",
          "arn:${data.aws_partition.current.partition}:s3:::shubham-terraform-state-cloud/${local.terraform_state_key}*"
        ]
      },
      {
        Sid = "LambdaDeploymentAccess"
        Action = [
          "lambda:*"
        ]
        Effect   = "Allow"
        Resource = "arn:${data.aws_partition.current.partition}:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${var.project_name}-chat"
      },
      {
        Sid = "ApiGatewayProjectAccess"
        Action = [
          "apigateway:*"
        ]
        Effect   = "Allow"
        Resource = "arn:${data.aws_partition.current.partition}:apigateway:${var.aws_region}::/apis*"
      },
      {
        Sid = "CloudWatchLogsAccess"
        Action = [
          "logs:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        # Terraform's AWS provider performs several global read/list calls while
        # refreshing state; keep these explicit so CI does not fail one API at a time.
        Sid = "ProviderGlobalRefreshReads"
        Action = [
          "iam:GetOpenIDConnectProvider",
          "iam:ListOpenIDConnectProviders",
          "logs:DescribeLogGroups",
          "s3:ListAllMyBuckets",
          "s3vectors:ListTagsForResource",
          "s3vectors:ListVectorBuckets"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "KnowledgeBaseBucketManagement"
        Action = [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:ListBucket",
          "s3:GetBucket*",
          "s3:PutBucket*",
          "s3:DeleteBucket*",
          "s3:GetEncryptionConfiguration",
          "s3:PutEncryptionConfiguration",
          "s3:GetLifecycleConfiguration",
          "s3:PutLifecycleConfiguration",
          "s3:DeleteLifecycleConfiguration",
          "s3:GetReplicationConfiguration",
          "s3:PutReplicationConfiguration",
          "s3:DeleteReplicationConfiguration",
          "s3:GetAccelerateConfiguration",
          "s3:PutAccelerateConfiguration",
          "s3:GetRequestPayment",
          "s3:PutRequestPayment",
          "s3:GetInventoryConfiguration",
          "s3:PutInventoryConfiguration",
          "s3:DeleteInventoryConfiguration",
          "s3:GetMetricsConfiguration",
          "s3:PutMetricsConfiguration",
          "s3:DeleteMetricsConfiguration",
          "s3:GetAnalyticsConfiguration",
          "s3:PutAnalyticsConfiguration",
          "s3:DeleteAnalyticsConfiguration",
          "s3:ListBucketMultipartUploads"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.knowledge_base.arn
      },
      {
        # S3 bucket refresh uses specific GetBucket* APIs that are easy to miss
        # when scoping CI permissions to a single project bucket.
        Sid = "KnowledgeBaseBucketRefreshReads"
        Action = [
          "s3:GetBucketAcl",
          "s3:GetBucketCORS",
          "s3:GetBucketLocation",
          "s3:GetBucketLogging",
          "s3:GetBucketNotification",
          "s3:GetBucketObjectLockConfiguration",
          "s3:GetBucketOwnershipControls",
          "s3:GetBucketPolicy",
          "s3:GetBucketPolicyStatus",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetBucketRequestPayment",
          "s3:GetBucketTagging",
          "s3:GetBucketVersioning",
          "s3:GetBucketWebsite",
          "s3:GetEncryptionConfiguration",
          "s3:GetLifecycleConfiguration",
          "s3:GetReplicationConfiguration"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.knowledge_base.arn
      },
      {
        Sid = "KnowledgeBaseObjectManagement"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectTagging",
          "s3:PutObjectTagging",
          "s3:DeleteObjectTagging",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.knowledge_base.arn}/*"
      },
      {
        Sid = "S3VectorsProjectAccess"
        Action = [
          "s3vectors:*"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3vectors_vector_bucket.knowledge_base.vector_bucket_arn,
          aws_s3vectors_index.knowledge_base.index_arn
        ]
      },
      {
        Sid = "BedrockKnowledgeBaseAccess"
        Action = [
          "bedrock:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "ProjectIamRoleAccess"
        Action = [
          "iam:AttachRolePolicy",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:DeleteRolePolicy",
          "iam:DetachRolePolicy",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies",
          "iam:ListRoleTags",
          "iam:PutRolePolicy",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:UpdateAssumeRolePolicy"
        ]
        Effect = "Allow"
        Resource = [
          aws_iam_role.lambda.arn,
          aws_iam_role.bedrock_knowledge_base.arn,
          aws_iam_role.github_actions.arn
        ]
      },
      {
        Sid = "PassOnlyProjectRuntimeRoles"
        Action = [
          "iam:PassRole"
        ]
        Effect = "Allow"
        Resource = [
          aws_iam_role.lambda.arn,
          aws_iam_role.bedrock_knowledge_base.arn
        ]
      },
      {
        Sid = "GithubOidcProviderRead"
        Action = [
          "iam:GetOpenIDConnectProvider",
          "iam:ListOpenIDConnectProviders"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
