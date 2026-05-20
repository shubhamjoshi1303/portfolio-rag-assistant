# Portfolio RAG Assistant

Serverless portfolio assistant using API Gateway, Lambda, Amazon Bedrock, and
Bedrock Knowledge Bases.

## Sync Knowledge Base

After Terraform uploads documents to S3 and creates the Bedrock Knowledge Base,
start ingestion with:

```bash
python3 scripts/sync_knowledge_base.py
```

To wait until ingestion finishes:

```bash
python3 scripts/sync_knowledge_base.py --wait
```

The script defaults to:

- Knowledge Base ID: `Y1YOTQ6UKB`
- Data Source ID: `EABKR7EQFA`
- Region: `us-east-1`

## GitHub Actions CI/CD

This repo uses GitHub Actions with the existing AWS OIDC federation pattern.
Do not create long-lived AWS access keys for CI/CD.

Configure these GitHub repository secrets:

- `AWS_ROLE_ARN`: existing IAM role ARN trusted by GitHub OIDC for this repository.
- `KNOWLEDGE_BASE_BUCKET_NAME`: `portfolio-rag-assistant-knowledge-base-640465964063-us-east-1`
- `KNOWLEDGE_BASE_S3_PREFIX`: `knowledge-base`
- `BEDROCK_KNOWLEDGE_BASE_ID`: `Y1YOTQ6UKB`
- `BEDROCK_DATA_SOURCE_ID`: `EABKR7EQFA`

The existing OIDC role trust policy should allow this repository on the `main`
branch to assume the role through `token.actions.githubusercontent.com`.

The role needs permissions for:

- Terraform remote state access to `shubham-terraform-state-cloud`
- Terraform-managed AWS resources in this project
- S3 read/write/delete/list access to the knowledge-base bucket
- Bedrock Knowledge Base ingestion: `bedrock:StartIngestionJob` and `bedrock:GetIngestionJob`

Workflows:

- `.github/workflows/deploy-infra.yml` runs Terraform init/fmt/validate/plan/apply for backend, Terraform, or script changes.
- `.github/workflows/sync-knowledge-base.yml` syncs `knowledge-base/` to S3 and starts Bedrock ingestion for document changes.
