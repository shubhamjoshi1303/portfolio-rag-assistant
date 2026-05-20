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
  name = "${var.project_name}-github-actions-policy"
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
          "lambda:AddPermission",
          "lambda:CreateFunction",
          "lambda:DeleteFunction",
          "lambda:GetFunction",
          "lambda:GetFunctionCodeSigningConfig",
          "lambda:GetPolicy",
          "lambda:ListVersionsByFunction",
          "lambda:RemovePermission",
          "lambda:TagResource",
          "lambda:UntagResource",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration"
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
        Sid = "CloudWatchLogsProjectAccess"
        Action = [
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:ListTagsForResource",
          "logs:PutRetentionPolicy",
          "logs:TagResource",
          "logs:UntagResource"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "KnowledgeBaseBucketAccess"
        Action = [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetBucketTagging",
          "s3:GetBucketVersioning",
          "s3:GetEncryptionConfiguration",
          "s3:ListBucket",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutBucketTagging",
          "s3:PutBucketVersioning",
          "s3:PutEncryptionConfiguration",
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:GetBucketEncryption",
          "s3:PutBucketEncryption",
          "s3:GetBucketAcl",
          "s3:GetBucketCORS",
          "s3:PutBucketCORS",
          "s3:DeleteBucketCORS",
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.knowledge_base.arn
      },
      {
        Sid = "KnowledgeBaseObjectAccess"
        Action = [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.knowledge_base.arn}/${var.knowledge_base_s3_prefix}/*"
      },
      {
        Sid = "S3VectorsProjectAccess"
        Action = [
          "s3vectors:CreateIndex",
          "s3vectors:CreateVectorBucket",
          "s3vectors:DeleteIndex",
          "s3vectors:DeleteVectorBucket",
          "s3vectors:DeleteVectors",
          "s3vectors:GetIndex",
          "s3vectors:GetVectorBucket",
          "s3vectors:GetVectorBucketPolicy",
          "s3vectors:GetVectors",
          "s3vectors:ListIndexes",
          "s3vectors:ListVectorBuckets",
          "s3vectors:PutVectorBucketPolicy",
          "s3vectors:PutVectors",
          "s3vectors:QueryVectors",
          "s3vectors:TagResource",
          "s3vectors:ListTagsForResource",
          "s3vectors:UntagResource"

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
          "bedrock:CreateDataSource",
          "bedrock:CreateKnowledgeBase",
          "bedrock:DeleteDataSource",
          "bedrock:DeleteKnowledgeBase",
          "bedrock:GetDataSource",
          "bedrock:GetIngestionJob",
          "bedrock:GetKnowledgeBase",
          "bedrock:ListDataSources",
          "bedrock:ListIngestionJobs",
          "bedrock:ListKnowledgeBases",
          "bedrock:StartIngestionJob",
          "bedrock:TagResource",
          "bedrock:UntagResource",
          "bedrock:UpdateDataSource",
          "bedrock:UpdateKnowledgeBase"
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
        Sid = "ReadGithubOidcProvider"
        Action = [
          "iam:GetOpenIDConnectProvider"
        ]
        Effect   = "Allow"
        Resource = data.aws_iam_openid_connect_provider.github_actions.arn
      }
    ]
  })
}
