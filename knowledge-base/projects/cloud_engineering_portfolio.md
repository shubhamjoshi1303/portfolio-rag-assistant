# Cloud Engineer Portfolio Website

## Short Summary

This project is a production-grade cloud engineering portfolio website built using React, AWS, and modern CI/CD deployment practices. The website was designed to showcase projects, certifications, backend engineering work, cloud architecture experience, and an integrated AI-powered RAG assistant through a polished developer-focused interface inspired by modern SaaS platforms such as Linear, Vercel, and Perplexity.

The project focuses heavily on real-world cloud deployment practices rather than just frontend design. The portfolio is hosted using a secure AWS static hosting architecture with Amazon S3, CloudFront, Route 53, Origin Access Control (OAC), GitHub Actions CI/CD pipelines, and automated deployment workflows. The platform now also includes a production-integrated Bedrock-powered RAG Portfolio Knowledge Assistant capable of answering questions about projects, certifications, AWS deployments, and technical experience using grounded retrieval from a custom knowledge base. 

---

# Problem

Traditional resume websites are often static, generic, and lack engineering depth. Most portfolios fail to demonstrate real deployment practices, infrastructure ownership, CI/CD workflows, AI integration, or cloud-native architecture decisions.

This project solves that problem by creating a fully production-deployed cloud portfolio platform that demonstrates:

* secure AWS hosting practices
* CI/CD automation
* modern frontend engineering
* infrastructure integration
* scalable deployment workflows
* real-world cloud architecture understanding
* AI-powered portfolio interaction using Retrieval-Augmented Generation (RAG)

The portfolio itself becomes a deployable cloud engineering and AI platform instead of simply displaying projects.

---

# Architecture

```text
React + Vite Frontend
        ↓
GitHub Repository
        ↓
GitHub Actions CI/CD Pipeline
        ↓
Amazon S3 (Private Bucket)
        ↓
CloudFront Distribution (OAC Protected)
        ↓
Route 53 Custom Domain
        ↓
HTTPS Delivery via ACM
```

### RAG Assistant Integration

```text
Portfolio Frontend
        ↓
API Gateway HTTP API
        ↓
AWS Lambda
        ↓
Amazon Bedrock Guardrails
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
Portfolio Knowledge Documents
```

### Deployment Flow

```text
Code Changes
    ↓
Git Push to Main
    ↓
GitHub Actions Build
    ↓
npm run build
    ↓
S3 Sync Deployment
    ↓
CloudFront Cache Invalidation
    ↓
Live Production Update
```

---

# My Role

I designed and implemented the complete frontend architecture, AWS hosting infrastructure, CI/CD pipeline, secure CloudFront + S3 integration, GitHub Actions deployment workflow, RAG assistant integration, and production domain configuration.

I also configured:

* Route 53 DNS
* ACM SSL certificates
* CloudFront Origin Access Control
* GitHub OIDC authentication for AWS deployment
* automated production deployment workflows
* API Gateway integration
* Bedrock-powered RAG assistant architecture
* Knowledge Base document structure
* Bedrock Guardrails configuration
* vector retrieval pipeline integration

Additionally, I designed the visual system and UI architecture using a monochrome SaaS-inspired design language focused on cloud engineering storytelling rather than traditional portfolio templates.

---

# Tech Stack

## AWS Services

* Amazon S3
* Amazon CloudFront
* Route 53
* AWS Certificate Manager (ACM)
* IAM
* Origin Access Control (OAC)
* AWS Lambda
* Amazon API Gateway
* Amazon Bedrock
* Bedrock Knowledge Bases
* Bedrock Guardrails
* Amazon Nova Micro
* Titan Embeddings
* Amazon S3 Vectors
* Amazon CloudWatch

## Frontend

* React
* Vite
* JavaScript
* Tailwind CSS

## Backend

* Python
* boto3

## DevOps / CI-CD

* GitHub Actions
* GitHub OIDC Federation
* Terraform
* Automated S3 deployment
* CloudFront invalidation workflows
* Remote Terraform state management

---

# Key Features

* Fully production-hosted cloud engineering portfolio
* Secure private S3 hosting behind CloudFront OAC
* Automated CI/CD deployment pipeline using GitHub Actions
* HTTPS custom domain configuration
* Responsive modern SaaS-style UI
* Architecture-focused project presentation
* Production deployment visualization section
* AI-powered RAG portfolio assistant
* Bedrock Knowledge Base integration
* Titan Embeddings semantic retrieval
* Grounded project/document responses
* Bedrock Guardrails for safer AI behavior
* Cloud-native deployment workflow
* Monochrome premium UI aesthetic
* Serverless AI integration architecture

---

# Important Design Decisions

I chose Amazon S3 + CloudFront instead of Amplify because I wanted deeper control over AWS infrastructure and deployment architecture. This approach better demonstrates practical cloud engineering knowledge, CDN configuration, OAC security, and CI/CD deployment integration.

CloudFront Origin Access Control was used instead of public bucket hosting to ensure the S3 bucket remains private while still serving content globally through CloudFront.

GitHub OIDC federation was implemented instead of long-term AWS access keys to follow modern secure CI/CD authentication practices.

The RAG assistant was implemented using Amazon Bedrock Knowledge Bases, Titan Embeddings, and S3 Vectors to create a fully AWS-native Retrieval-Augmented Generation architecture without managing custom vector databases or model infrastructure.

I chose a serverless architecture for the assistant because chatbot traffic is intermittent and request durations are short-lived, making Lambda and API Gateway more cost-efficient than always-running compute infrastructure.

The frontend aesthetic intentionally avoids traditional resume-template design in favor of a minimal engineering-focused interface inspired by modern infrastructure and AI companies.

---

# Challenges

* Debugging Route 53 and CloudFront DNS propagation
* Configuring CloudFront with private S3 bucket access using OAC
* Setting up GitHub OIDC federation with IAM roles
* Managing CloudFront cache invalidation behavior
* Fixing CI/CD deployment permissions and IAM policy scopes
* Handling Vite production build behavior
* Designing a responsive monochrome UI without sacrificing readability
* Structuring project sections to balance engineering depth and visual simplicity
* Resolving CORS issues between frontend and serverless backend
* Debugging API Gateway and Lambda response formatting
* Managing Terraform state drift and existing AWS resources
* Configuring Bedrock Knowledge Base retrieval flows
* Debugging Bedrock model invocation through Lambda
* Ensuring grounded responses from portfolio documents instead of generic AI outputs

---

# Final Outcome

The project successfully deployed a live production portfolio website using a fully automated AWS deployment pipeline. Any push to the GitHub repository automatically builds the React application, deploys assets to S3, invalidates CloudFront cache, and updates the live production website globally.

The portfolio now acts as:

* a professional resume platform
* a cloud engineering showcase
* a CI/CD deployment demonstration
* an AI-powered portfolio knowledge assistant
* a serverless RAG application
* a foundation for future AI-powered architecture visualization systems

The integrated RAG assistant allows visitors to ask questions about projects, certifications, AWS experience, and technical background using grounded retrieval from a custom knowledge base powered entirely by AWS-native GenAI services.

Live Website:

[shubhamjoshi.xyz](https://shubhamjoshi.xyz?utm_source=chatgpt.com)

GitHub Repository:

[Cloud Portfolio Repository](https://github.com/shubhamjoshi1303?utm_source=chatgpt.com)

---

# Interview Pitch

I built and deployed a production-grade cloud engineering portfolio website using React, Amazon S3, CloudFront, Route 53, GitHub Actions, Terraform, and secure AWS deployment practices. The project wasn’t just about frontend development — the primary focus was building a real cloud-native deployment pipeline, infrastructure architecture, and AI-powered portfolio experience.

I configured private S3 hosting behind CloudFront using Origin Access Control, implemented automated CI/CD deployment pipelines with GitHub Actions and GitHub OIDC federation, and connected the platform to a custom domain with HTTPS delivery through ACM and Route 53.

I also integrated a serverless RAG-based portfolio assistant using Amazon Bedrock, Bedrock Knowledge Bases, Titan Embeddings, S3 Vectors, Lambda, API Gateway, and Bedrock Guardrails. The assistant retrieves grounded information from my portfolio knowledge base and answers questions about my projects, certifications, AWS deployments, and technical background.

One of the biggest learning experiences from the project was debugging production cloud deployment issues across CloudFront, API Gateway, Lambda, Terraform, Vite frontend builds, and Bedrock retrieval pipelines while ensuring the assistant remained grounded in portfolio-specific knowledge rather than generating generic responses.
