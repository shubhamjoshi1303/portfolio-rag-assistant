data "archive_file" "lambda" {
  type = "zip"
  # Keep the Lambda module at the zip root so the configured handler
  # lambda_function.lambda_handler resolves correctly at runtime.
  # boto3/botocore are provided by the Python 3.12 Lambda managed runtime,
  # so this package stays deterministic and does not run pip during apply.
  source_file = "${path.module}/../backend/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "chat" {
  function_name    = "${var.project_name}-chat"
  role             = aws_iam_role.lambda.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  timeout          = 15
  memory_size      = 256

  tags = local.common_tags

  # The function can already exist in AWS while missing from Terraform state.
  # Import it before applying in that case:
  # terraform import aws_lambda_function.chat portfolio-rag-assistant-chat
  depends_on = [
    aws_iam_role_policy.lambda_logging
  ]
}
