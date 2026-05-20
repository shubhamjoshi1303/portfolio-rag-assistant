````md id="d6v4ks"
# RAG Portfolio Knowledge Assistant

## Short Summary

This project is a serverless AI-powered portfolio knowledge assistant built to answer questions about Shubham Joshi’s projects, AWS deployments, certifications, coursework, and technical background. The assistant is integrated directly into a production React portfolio website and uses Retrieval-Augmented Generation (RAG) to provide grounded responses from a custom knowledge base instead of generic LLM outputs.

The system uses Amazon Bedrock, Bedrock Knowledge Bases, Application layer Guardrails, Amazon Nova Micro, Titan Embeddings, S3 Vectors, AWS Lambda, API Gateway, S3, CloudWatch, and Terraform to create a scalable, safe, and low-cost cloud-native AI application.

---

# Problem

Traditional portfolio websites are static and require recruiters or visitors to manually browse projects and resume sections. This project solves that by allowing users to ask natural language questions about my background, projects, certifications, and AWS experience.

The assistant retrieves relevant information from my curated portfolio knowledge base and generates grounded answers while using Guardrails to reduce unsafe, off-topic, or unsupported responses.

---

# Architecture

```text
React Portfolio on S3 + CloudFront
                ↓
API Gateway HTTP API
                ↓
AWS Lambda
                ↓
Application layer Guardrails
                ↓
Amazon Bedrock Knowledge Bases
                ↓
RetrieveAndGenerate
                ↓
Amazon Nova Micro
                ↓
Titan Embeddings
                ↓
S3 Vectors
                ↓
S3 Knowledge Documents
```

---

Infrastructure is provisioned using Terraform with remote S3 state management.

---

# My Role

I designed and deployed the full serverless architecture, integrated the React frontend with API Gateway, configured Terraform-managed infrastructure, implemented the Bedrock invocation flow, built the RAG pipeline, prepared the knowledge base documents, configured Titan Embeddings and vector retrieval, and added Application layer Guardrails for safer public-facing AI responses.

I also debugged production issues involving:

* CORS
* Vite environment variables
* API Gateway response formatting
* Lambda integration
* Terraform state drift
* Bedrock invocation
* frontend/backend API connectivity

---

# Tech Stack

## AWS Services

* Amazon Bedrock
* Amazon Bedrock Knowledge Bases
* Amazon Nova Micro
* Amazon Titan Embeddings
* Amazon S3 Vectors
* AWS Lambda
* Amazon API Gateway
* Amazon S3
* Amazon CloudFront
* Amazon CloudWatch
* AWS IAM
* Terraform remote S3 backend

---

## Frontend / Backend

* React
* Vite
* Python
* boto3
* GitHub Actions

---

## Infrastructure / DevOps

* Terraform
* GitHub Actions CI/CD
* CloudFront invalidation
* Remote Terraform state

---

# Key Features

* AI-powered portfolio assistant embedded in a live React portfolio
* Retrieval-Augmented Generation over custom project and resume documents
* Bedrock Knowledge Bases for managed RAG retrieval
* Titan Embeddings for semantic document representation
* S3 Vectors for vector storage
* Amazon Nova Micro for low-cost answer generation
* Application layer Guardrails for safety, topic control, and responsible AI behavior
* Source-grounded responses from curated portfolio knowledge documents
* API Gateway + Lambda serverless backend
* Terraform-managed AWS infrastructure
* CloudWatch logging and debugging
* Frontend/backend integration with production API deployment

---

# Important Design Decisions

I chose a serverless architecture instead of always-on compute because the chatbot has intermittent traffic and short-lived inference requests. API Gateway and Lambda keep the system cost-efficient while still supporting production usage.

I chose Amazon Bedrock because it provides managed access to foundation models, Knowledge Bases, Titan Embeddings, and Guardrails in one AWS-native AI stack. This allowed the project to demonstrate both RAG architecture and responsible AI controls without managing custom model infrastructure.

I used Terraform so the backend infrastructure could be recreated, version-controlled, and managed consistently across deployments.

---

# Challenges

* Debugging API Gateway/Lambda proxy response formatting
* Fixing frontend production environment variable injection with Vite and GitHub Actions
* Resolving CORS issues between localhost and CloudFront-hosted production frontend
* Reconciling Terraform state drift with existing AWS resources
* Handling Lambda deployment conflicts and stale API Gateway permissions
* Debugging Bedrock model invocation from Lambda
* Designing the RAG flow with Knowledge Bases, Titan Embeddings, S3 Vectors, and Guardrails
* Ensuring the chatbot stays grounded in portfolio documents instead of producing generic answers

---

# Final Outcome

The final system is a production-ready serverless RAG assistant integrated into my live React portfolio website. It allows visitors to ask questions about my projects, certifications, AWS experience, and technical background.

The assistant uses Amazon Bedrock Knowledge Bases, Titan Embeddings, S3 Vectors, and Amazon Nova Micro to retrieve and generate grounded responses from my own portfolio knowledge documents. application layer Guardrails are included to add safety controls, reduce off-topic responses, and support responsible public-facing AI behavior.

---

# Interview Pitch

I built a serverless RAG-based portfolio knowledge assistant using React, API Gateway, AWS Lambda, Amazon Bedrock, Bedrock Knowledge Bases, application layer Guardrails, Titan Embeddings, S3 Vectors, S3, CloudWatch, and Terraform. The assistant is embedded into my live portfolio website and answers questions about my projects, certifications, AWS deployments, and technical background using grounded retrieval from my own knowledge base.

The project was focused on cloud architecture and production integration, not just building a chatbot UI. I implemented the serverless backend, connected the frontend to API Gateway, managed the infrastructure with Terraform, integrated Bedrock inference, added RAG retrieval with Knowledge Bases and vector storage, and included Guardrails for safe public AI usage.
````
