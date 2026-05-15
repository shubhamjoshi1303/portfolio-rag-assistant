import base64
import binascii
import json
import os

import boto3
from botocore.exceptions import BotoCoreError, ClientError


MODEL_ID = os.environ.get("BEDROCK_MODEL_ID", "amazon.nova-micro-v1:0")


def _response(status_code, body):
    response = {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json",
        },
        "body": json.dumps(body),
    }
    print("Final API response:", response)
    return response


def _success_response(answer, sources):
    return _response(
        200,
        {
            "answer": answer,
            "sources": sources,
        },
    )


def _error_response(error):
    return _response(
        500,
        {
            "message": str(error),
        },
    )


def _parse_body(event):
    raw_body = event.get("body")
    if raw_body is None:
        raise ValueError("Request body is required.")

    if event.get("isBase64Encoded"):
        try:
            raw_body = base64.b64decode(raw_body).decode("utf-8")
        except (binascii.Error, UnicodeDecodeError) as exc:
            raise ValueError("Request body must be valid JSON.") from exc

    try:
        body = json.loads(raw_body)
    except (TypeError, json.JSONDecodeError) as exc:
        raise ValueError("Request body must be valid JSON.") from exc

    if not isinstance(body, dict):
        raise ValueError("Request body must be a JSON object.")

    message = body.get("message")
    if not isinstance(message, str) or not message.strip():
        raise ValueError("Request body must include a non-empty message field.")

    return message.strip()


def _extract_answer(response_body):
    content = response_body.get("output", {}).get("message", {}).get("content", [])
    text_parts = [
        item.get("text", "")
        for item in content
        if isinstance(item, dict) and item.get("text")
    ]

    return "".join(text_parts).strip()


def lambda_handler(event, context):
    try:
        message = _parse_body(event)

        request_body = {
            "messages": [
                {
                    "role": "user",
                    "content": [{"text": message}],
                }
            ],
            "inferenceConfig": {
                "maxTokens": 512,
                "temperature": 0.7,
                "topP": 0.9,
            },
        }

        bedrock_runtime = boto3.client("bedrock-runtime")
        response = bedrock_runtime.invoke_model(
            modelId=MODEL_ID,
            contentType="application/json",
            accept="application/json",
            body=json.dumps(request_body),
        )
        response_body = json.loads(response["body"].read())
        answer = _extract_answer(response_body)

        if not answer:
            raise ValueError("Bedrock returned an empty response.")

        return _success_response(answer, [])
    except (
        ValueError,
        BotoCoreError,
        ClientError,
        KeyError,
        json.JSONDecodeError,
    ) as exc:
        return _error_response(exc)


# Compatibility for any existing Lambda version still configured with
# lambda_function.handler before Terraform updates it to lambda_handler.
handler = lambda_handler
