import base64
import binascii
import json
import os
from pathlib import PurePosixPath
import traceback

import boto3
from botocore.exceptions import BotoCoreError, ClientError


MODEL_ID = os.environ.get("BEDROCK_MODEL_ID", "amazon.nova-micro-v1:0")
AWS_REGION = os.environ.get("AWS_REGION", "us-east-1")
MODEL_ARN = os.environ.get(
    "BEDROCK_MODEL_ARN",
    f"arn:aws:bedrock:{AWS_REGION}::foundation-model/{MODEL_ID}",
)
KNOWLEDGE_BASE_ID = os.environ.get("BEDROCK_KNOWLEDGE_BASE_ID", "Y1YOTQ6UKB")
DEFAULT_ORIGIN = "https://shubhamjoshi.xyz"
ALLOWED_ORIGINS = {
    "http://localhost:5173",
    "https://shubhamjoshi.xyz",
    "https://www.shubhamjoshi.xyz",
    "https://portfolio.shubhamjoshi.xyz",
}
MAX_HISTORY_MESSAGES = 6


class BadRequestError(ValueError):
    pass


def _log(message, **fields):
    print(json.dumps({"message": message, **fields}, default=str))


def _headers(origin):
    allowed_origin = origin if origin in ALLOWED_ORIGINS else DEFAULT_ORIGIN
    return {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": allowed_origin,
        "Access-Control-Allow-Headers": "content-type,authorization",
        "Access-Control-Allow-Methods": "POST,OPTIONS",
    }


def _response(status_code, origin, body):
    body_json = json.dumps(body)
    response = {
        "statusCode": int(status_code),
        "headers": _headers(origin),
        "body": body_json,
    }
    _log("final response", statusCode=response["statusCode"])
    print("Final API response:", response)
    # API Gateway HTTP API expects the outer response object as a dict.
    # Only the body field is JSON-encoded.
    return response


def _event_headers(event):
    headers = event.get("headers") or {}
    return {str(key).lower(): value for key, value in headers.items()}


def _request_method(event):
    request_context = event.get("requestContext") or {}
    http_context = request_context.get("http") or {}
    return (
        http_context.get("method")
        or event.get("httpMethod")
        or event.get("requestContext", {}).get("httpMethod")
        or ""
    ).upper()


def _request_path(event):
    request_context = event.get("requestContext") or {}
    http_context = request_context.get("http") or {}
    return event.get("rawPath") or http_context.get("path") or event.get("path") or ""


def _decode_body(event):
    raw_body = event.get("body")
    if raw_body is None or raw_body == "":
        raise BadRequestError("Request body is required.")

    if event.get("isBase64Encoded") is True:
        try:
            return base64.b64decode(raw_body, validate=True).decode("utf-8")
        except (binascii.Error, UnicodeDecodeError) as exc:
            raise BadRequestError("Request body must be valid JSON.") from exc

    return raw_body


def _parse_request(event):
    raw_body = _decode_body(event)

    try:
        body = json.loads(raw_body)
    except json.JSONDecodeError as exc:
        raise BadRequestError("Request body must be valid JSON.") from exc

    if not isinstance(body, dict):
        raise BadRequestError("Request body must be a JSON object.")

    if "message" not in body:
        raise BadRequestError("Request body must include a message field.")

    message = body["message"]
    if not isinstance(message, str):
        raise BadRequestError("Message must be a string.")

    message = message.strip()
    if not message:
        raise BadRequestError("Message must not be empty.")

    history = body.get("history", [])
    if history is None:
        history = []

    if not isinstance(history, list):
        raise BadRequestError("History must be a list.")

    validated_history = []
    for index, item in enumerate(history):
        if not isinstance(item, dict):
            raise BadRequestError(f"History item {index} must be an object.")

        if "role" not in item or "content" not in item:
            raise BadRequestError(
                f"History item {index} must include role and content."
            )

        role = item["role"]
        content = item["content"]

        if role not in {"user", "assistant"}:
            raise BadRequestError(
                f"History item {index} role must be user or assistant."
            )

        if not isinstance(content, str):
            raise BadRequestError(f"History item {index} content must be a string.")

        validated_history.append(
            {
                "role": role,
                "content": content,
            }
        )

    history_used = validated_history[-MAX_HISTORY_MESSAGES:]

    return message, validated_history, history_used


def _nova_message(role, content):
    return {
        "role": role,
        "content": [
            {
                "text": content,
            }
        ],
    }


def _sanitize_history_for_bedrock(history):
    leading_assistant_messages_dropped = 0
    while history and history[0]["role"] == "assistant":
        history = history[1:]
        leading_assistant_messages_dropped += 1

    alternating_history = []
    expected_role = "user"
    for item in history:
        if item["role"] != expected_role:
            continue

        alternating_history.append(item)
        expected_role = "assistant" if expected_role == "user" else "user"

    return alternating_history, leading_assistant_messages_dropped


def _nova_payload(message, history):
    bedrock_history, leading_assistant_messages_dropped = _sanitize_history_for_bedrock(
        history
    )
    _log(
        "bedrock history prepared",
        leading_assistant_messages_dropped=leading_assistant_messages_dropped,
        history_messages_sent=len(bedrock_history),
    )

    messages = [_nova_message(item["role"], item["content"]) for item in bedrock_history]
    messages.append(_nova_message("user", message))

    return {
        "messages": messages,
        "inferenceConfig": {
            "maxTokens": 512,
            "temperature": 0.7,
            "topP": 0.9,
        },
    }


def _extract_answer(response_body):
    content = response_body.get("output", {}).get("message", {}).get("content", [])
    if not isinstance(content, list):
        return ""

    text_parts = []
    for item in content:
        if isinstance(item, dict) and isinstance(item.get("text"), str):
            text_parts.append(item["text"])

    return "".join(text_parts).strip()


def _invoke_bedrock_model(message, history):
    bedrock_runtime = boto3.client("bedrock-runtime")
    response = bedrock_runtime.invoke_model(
        modelId=MODEL_ID,
        contentType="application/json",
        accept="application/json",
        body=json.dumps(_nova_payload(message, history)),
    )
    response_body = json.loads(response["body"].read())
    _log("bedrock response", response_keys=sorted(response_body.keys()))

    answer = _extract_answer(response_body)
    if not answer:
        raise RuntimeError("Bedrock returned an empty response.")

    return answer


def _history_query_text(message, history):
    if not history:
        return message

    lines = ["Recent conversation context:"]
    for item in history:
        label = "User" if item["role"] == "user" else "Assistant"
        lines.append(f"{label}: {item['content']}")

    lines.extend(
        [
            "",
            "Current user question:",
            message,
            "",
            "Answer the current user question using the portfolio knowledge base.",
        ]
    )
    return "\n".join(lines)


def _location_uri(location):
    if not isinstance(location, dict):
        return ""

    for key in (
        "s3Location",
        "webLocation",
        "confluenceLocation",
        "salesforceLocation",
        "sharePointLocation",
        "customDocumentLocation",
        "kendraDocumentLocation",
    ):
        value = location.get(key)
        if isinstance(value, dict):
            uri = value.get("uri") or value.get("url")
            if isinstance(uri, str):
                return uri

    return ""


def _source_title(uri, metadata):
    for key in ("title", "document_title", "source", "x-amz-bedrock-kb-source-uri"):
        value = metadata.get(key) if isinstance(metadata, dict) else None
        if isinstance(value, str) and value.strip():
            if value.startswith("s3://"):
                return PurePosixPath(value).name or value
            return value.strip()

    if uri:
        return PurePosixPath(uri).name or uri

    return "Knowledge base source"


def _source_snippet(reference):
    content = reference.get("content") if isinstance(reference, dict) else {}
    if not isinstance(content, dict):
        return ""

    text = content.get("text")
    if isinstance(text, str):
        return text.strip()

    byte_content = content.get("byteContent")
    if isinstance(byte_content, str):
        return byte_content[:500]

    row = content.get("row")
    if isinstance(row, list):
        return " ".join(str(item) for item in row)[:500]

    return ""


def _extract_sources(response_body):
    sources = []
    seen = set()

    for citation in response_body.get("citations", []):
        for reference in citation.get("retrievedReferences", []):
            if not isinstance(reference, dict):
                continue

            metadata = reference.get("metadata") or {}
            uri = _location_uri(reference.get("location") or {})
            snippet = _source_snippet(reference)
            title = _source_title(uri, metadata)
            dedupe_key = (uri, snippet[:120])

            if dedupe_key in seen:
                continue

            seen.add(dedupe_key)
            sources.append(
                {
                    "title": title,
                    "uri": uri,
                    "snippet": snippet,
                }
            )

    return sources


def _retrieve_and_generate(message, history):
    query_text = _history_query_text(message, history)
    client = boto3.client("bedrock-agent-runtime")
    response_body = client.retrieve_and_generate(
        input={
            "text": query_text,
        },
        retrieveAndGenerateConfiguration={
            "type": "KNOWLEDGE_BASE",
            "knowledgeBaseConfiguration": {
                "knowledgeBaseId": KNOWLEDGE_BASE_ID,
                "modelArn": MODEL_ARN,
                "retrievalConfiguration": {
                    "vectorSearchConfiguration": {
                        "numberOfResults": 5,
                    }
                },
            },
        },
    )
    _log(
        "retrieve_and_generate response",
        response_keys=sorted(response_body.keys()),
        citations_count=len(response_body.get("citations", [])),
    )

    answer = response_body.get("output", {}).get("text", "").strip()
    if not answer:
        raise RuntimeError("Bedrock Knowledge Base returned an empty response.")

    sources = _extract_sources(response_body)
    _log("retrieve_and_generate sources parsed", sources_count=len(sources))
    return answer, sources


def _generate_answer(message, history):
    try:
        return _retrieve_and_generate(message, history)
    except (BotoCoreError, ClientError, KeyError, TypeError, RuntimeError) as exc:
        _log(
            "retrieve_and_generate failed; falling back to invoke_model",
            detail=_safe_error_detail(exc),
        )
        answer = _invoke_bedrock_model(message, history)
        return answer, []


def _safe_error_detail(error):
    if isinstance(error, ClientError):
        error_info = error.response.get("Error", {})
        code = error_info.get("Code", "ClientError")
        message = error_info.get("Message", "Bedrock client error.")
        return f"{code}: {message}"[:300]

    return str(error)[:300]


def lambda_handler(event, context):
    headers = _event_headers(event)
    origin = headers.get("origin")
    method = _request_method(event)
    path = _request_path(event)

    _log(
        "request received",
        method=method,
        origin=origin,
        path=path,
        event_keys=sorted(event.keys()),
    )

    if method == "OPTIONS":
        return _response(200, origin, {})

    if method != "POST" or path != "/chat":
        return _response(
            404,
            origin,
            {
                "message": "Not found",
                "detail": "Use POST /chat.",
            },
        )

    try:
        message, history_received, history_used = _parse_request(event)
        _log(
            "parsed message",
            current_message=message,
            history_messages_received=len(history_received),
            history_messages_used=len(history_used),
        )

        answer, sources = _generate_answer(message, history_used)
        return _response(
            200,
            origin,
            {
                "answer": answer,
                "sources": sources,
            },
        )
    except BadRequestError as exc:
        _log("bad request", detail=str(exc))
        return _response(
            400,
            origin,
            {
                "message": "Bad request",
                "detail": str(exc),
            },
        )
    except (BotoCoreError, ClientError, KeyError, TypeError, RuntimeError) as exc:
        print("Unhandled exception:", traceback.format_exc())
        return _response(
            500,
            origin,
            {
                "message": "Internal server error",
                "detail": _safe_error_detail(exc),
            },
        )
    except Exception as exc:
        print("Unhandled exception:", traceback.format_exc())
        return _response(
            500,
            origin,
            {
                "message": "Internal server error",
                "detail": _safe_error_detail(exc),
            },
        )


# Compatibility for any existing Lambda version still configured with
# lambda_function.handler before Terraform updates it to lambda_handler.
handler = lambda_handler
