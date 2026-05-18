import base64
import binascii
import json
import os
import traceback

import boto3
from botocore.exceptions import BotoCoreError, ClientError


MODEL_ID = os.environ.get("BEDROCK_MODEL_ID", "amazon.nova-micro-v1:0")
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


def _nova_payload(message, history):
    messages = [_nova_message(item["role"], item["content"]) for item in history]
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


def _invoke_bedrock(message, history):
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

        answer = _invoke_bedrock(message, history_used)
        return _response(
            200,
            origin,
            {
                "answer": answer,
                "sources": [],
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
