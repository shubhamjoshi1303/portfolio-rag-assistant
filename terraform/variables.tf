variable "aws_region" {
  description = "AWS region for deployment."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "portfolio-rag-assistant"
}

variable "knowledge_base_s3_prefix" {
  description = "S3 prefix for uploaded knowledge-base documents."
  type        = string
  default     = "knowledge-base"
}
