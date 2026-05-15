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
