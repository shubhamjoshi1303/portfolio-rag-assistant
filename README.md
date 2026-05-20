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

- Knowledge Base ID: set with `BEDROCK_KNOWLEDGE_BASE_ID`
- Data Source ID: set with `BEDROCK_DATA_SOURCE_ID`
- Region: set with `AWS_REGION`

## GitHub Actions CI/CD

This repo uses GitHub Actions with the existing AWS OIDC federation pattern.
Do not create long-lived AWS access keys for CI/CD.

Configure these GitHub repository secrets:

- `AWS_ROLE_ARN`: `arn:aws:iam::<account-id>:role/<github-actions-role-name>`
- `KNOWLEDGE_BASE_BUCKET_NAME`: `<terraform-managed-knowledge-base-bucket>`
- `KNOWLEDGE_BASE_S3_PREFIX`: `<knowledge-base-prefix>`
- `BEDROCK_KNOWLEDGE_BASE_ID`: `<bedrock-knowledge-base-id>`
- `BEDROCK_DATA_SOURCE_ID`: `<bedrock-data-source-id>`

Terraform manages the dedicated GitHub Actions role:

```text
arn:aws:iam::<account-id>:role/<github-actions-role-name>
```

The role trust policy allows only this repository on the `main` branch to assume
the role through `token.actions.githubusercontent.com`:

```text
repo:<github-owner>/<github-repo>:ref:refs/heads/main
```

The role is scoped for:

- Terraform remote state access to the configured Terraform backend bucket
- Terraform-managed AWS resources in this project
- S3 read/write/delete/list access to the knowledge-base bucket
- Bedrock Knowledge Base ingestion: `bedrock:StartIngestionJob` and `bedrock:GetIngestionJob`
- `iam:PassRole` only for this project’s Lambda and Bedrock Knowledge Base roles

Workflows:

- `.github/workflows/deploy-infra.yml` runs Terraform init/fmt/validate/plan/apply for backend, Terraform, or script changes.
- `.github/workflows/sync-knowledge-base.yml` syncs `knowledge-base/` to S3 and starts Bedrock ingestion for document changes.
