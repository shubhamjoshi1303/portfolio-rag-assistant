resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.project_name}-chat"
  retention_in_days = 14

  tags = local.common_tags
}
