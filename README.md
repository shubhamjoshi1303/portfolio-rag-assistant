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
