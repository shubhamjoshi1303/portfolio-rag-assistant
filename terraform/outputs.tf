output "api_endpoint" {
  description = "Base URL for the API Gateway HTTP API."
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "chat_endpoint" {
  description = "POST endpoint for chat requests."
  value       = "${aws_apigatewayv2_stage.default.invoke_url}/chat"
}

output "lambda_function_name" {
  description = "Name of the mock chat Lambda function."
  value       = aws_lambda_function.chat.function_name
}

output "knowledge_base_bucket_name" {
  description = "S3 bucket storing knowledge-base source documents."
  value       = aws_s3_bucket.knowledge_base.bucket
}

output "knowledge_base_s3_prefix" {
  description = "S3 prefix containing uploaded knowledge-base documents."
  value       = var.knowledge_base_s3_prefix
}

output "bedrock_knowledge_base_id" {
  description = "Amazon Bedrock Knowledge Base ID."
  value       = aws_bedrockagent_knowledge_base.portfolio.id
}

output "bedrock_data_source_id" {
  description = "Amazon Bedrock Knowledge Base data source ID."
  value       = aws_bedrockagent_data_source.s3_documents.data_source_id
}

output "knowledge_base_role_arn" {
  description = "IAM role ARN used by Amazon Bedrock Knowledge Bases."
  value       = aws_iam_role.bedrock_knowledge_base.arn
}

output "github_actions_role_arn" {
  description = "IAM role ARN assumed by GitHub Actions through OIDC."
  value       = aws_iam_role.github_actions.arn
}
