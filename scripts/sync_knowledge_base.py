import argparse
import time

import boto3
from botocore.exceptions import ClientError


DEFAULT_KNOWLEDGE_BASE_ID = "Y1YOTQ6UKB"
DEFAULT_DATA_SOURCE_ID = "EABKR7EQFA"
TERMINAL_STATUSES = {"COMPLETE", "FAILED", "STOPPED"}


def parse_args():
    parser = argparse.ArgumentParser(
        description="Start a Bedrock Knowledge Base ingestion job."
    )
    parser.add_argument(
        "--knowledge-base-id",
        default=DEFAULT_KNOWLEDGE_BASE_ID,
        help="Bedrock Knowledge Base ID.",
    )
    parser.add_argument(
        "--data-source-id",
        default=DEFAULT_DATA_SOURCE_ID,
        help="Bedrock Knowledge Base data source ID.",
    )
    parser.add_argument(
        "--region",
        default="us-east-1",
        help="AWS region.",
    )
    parser.add_argument(
        "--wait",
        action="store_true",
        help="Poll until the ingestion job reaches a terminal status.",
    )
    parser.add_argument(
        "--poll-seconds",
        type=int,
        default=15,
        help="Seconds between polling attempts when --wait is used.",
    )
    return parser.parse_args()


def start_ingestion_job(client, knowledge_base_id, data_source_id):
    response = client.start_ingestion_job(
        knowledgeBaseId=knowledge_base_id,
        dataSourceId=data_source_id,
    )
    return response["ingestionJob"]


def get_ingestion_job(client, knowledge_base_id, data_source_id, ingestion_job_id):
    response = client.get_ingestion_job(
        knowledgeBaseId=knowledge_base_id,
        dataSourceId=data_source_id,
        ingestionJobId=ingestion_job_id,
    )
    return response["ingestionJob"]


def main():
    args = parse_args()
    client = boto3.client("bedrock-agent", region_name=args.region)

    try:
        ingestion_job = start_ingestion_job(
            client,
            args.knowledge_base_id,
            args.data_source_id,
        )
    except ClientError as exc:
        error = exc.response.get("Error", {})
        raise SystemExit(
            f"Failed to start ingestion job: {error.get('Code')}: {error.get('Message')}"
        ) from exc

    ingestion_job_id = ingestion_job["ingestionJobId"]
    status = ingestion_job["status"]
    print(f"Ingestion job id: {ingestion_job_id}")
    print(f"Status: {status}")
    if "statistics" in ingestion_job:
        print(f"Statistics: {ingestion_job['statistics']}")

    if not args.wait:
        return

    while status not in TERMINAL_STATUSES:
        time.sleep(args.poll_seconds)
        ingestion_job = get_ingestion_job(
            client,
            args.knowledge_base_id,
            args.data_source_id,
            ingestion_job_id,
        )
        status = ingestion_job["status"]
        print(f"Status: {status}")
        if "statistics" in ingestion_job:
            print(f"Statistics: {ingestion_job['statistics']}")

    if status == "FAILED":
        print(f"Failure reasons: {ingestion_job.get('failureReasons', [])}")
        raise SystemExit(1)


if __name__ == "__main__":
    main()
