# My Website Deployment

## Short Summary

This project focuses on the deployment architecture, cloud infrastructure, CI/CD workflows, and production hosting pipeline behind my personal portfolio website. The website was built using React, AWS, and modern cloud deployment practices to create a scalable, secure, and production-grade frontend platform for showcasing projects, certifications, research work, backend systems, and cloud engineering experience.

The deployment architecture emphasizes real-world cloud engineering practices rather than just frontend development. The website is hosted using Amazon S3, CloudFront, Route53, Origin Access Control (OAC), ACM HTTPS certificates, GitHub Actions CI/CD pipelines, and automated deployment workflows. The platform also integrates a production-grade Bedrock-powered RAG Portfolio Knowledge Assistant capable of answering questions about projects, certifications, AWS deployments, and technical experience using grounded retrieval from a custom knowledge base.

---

# Problem

Most portfolio websites are static frontend projects that do not demonstrate real deployment architecture, infrastructure ownership, cloud-native workflows, CI/CD automation, or production engineering practices.

The goal of this project was to build and deploy a production-grade portfolio platform capable of demonstrating:

* secure AWS hosting practices
* cloud-native frontend deployment
* CI/CD automation
* infrastructure ownership
* production deployment workflows
* AI integration
* scalable cloud architecture
* modern frontend engineering
* serverless AI integration

The project transforms the portfolio itself into a deployable cloud engineering platform instead of simply acting as a resume website.

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

---

## RAG Assistant Integration

```text
Portfolio Frontend
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
Portfolio Knowledge Documents
```

---

## Deployment Flow

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

I designed and implemented the complete frontend deployment architecture, AWS hosting infrastructure, CI/CD pipeline, CloudFront + S3 integration, GitHub Actions deployment workflows, and production domain configuration.

I also configured:

* Route53 DNS records
* ACM SSL certificates
* CloudFront Origin Access Control
* GitHub OIDC authentication for AWS deployments
* automated deployment pipelines
* frontend production environment configuration
* API Gateway integration
* Bedrock-powered RAG assistant integration
* Knowledge Base document structure
* vector retrieval integration
* Application layer Guardrails configuration

Additionally, I designed the frontend UI and visual system using a monochrome SaaS-inspired interface influenced by modern engineering platforms such as Linear, Vercel, and Perplexity.

---

# Tech Stack

## AWS Services

* Amazon S3
* Amazon CloudFront
* Amazon Route53
* AWS Certificate Manager (ACM)
* IAM
* Origin Access Control (OAC)
* AWS Lambda
* Amazon API Gateway
* Amazon Bedrock
* Bedrock Knowledge Bases
* Application layer Guardrails
* Amazon Nova Micro
* Titan Embeddings
* Amazon S3 Vectors
* Amazon CloudWatch

---

## Frontend

* React
* Vite
* JavaScript
* Tailwind CSS

---

## Backend

* Python
* boto3

---

## DevOps / CI-CD

* GitHub Actions
* GitHub OIDC Federation
* Terraform
* Automated S3 deployment workflows
* CloudFront invalidation workflows
* Remote Terraform state management

---

# Key Features

* Production-hosted cloud-native portfolio website
* Secure private S3 hosting behind CloudFront OAC
* Automated CI/CD deployment pipeline
* HTTPS custom domain configuration
* Responsive SaaS-inspired UI
* Architecture-focused project presentation
* AI-powered RAG portfolio assistant
* Bedrock Knowledge Base integration
* Titan Embeddings semantic retrieval
* Grounded AI responses from custom portfolio documents
* Application-layer Guardrails integration
* Cloud-native deployment workflow
* Serverless AI architecture integration
* Production deployment visualization sections

---

# Important Design Decisions

I chose Amazon S3 + CloudFront instead of Amplify because I wanted deeper control over deployment architecture, infrastructure configuration, OAC security, and CI/CD workflows.

CloudFront Origin Access Control was used instead of public S3 bucket hosting to ensure that the bucket remains private while still allowing global CDN delivery.

GitHub OIDC federation was implemented instead of long-term AWS access keys to follow modern secure deployment practices.

The RAG assistant was implemented using Amazon Bedrock Knowledge Bases, Titan Embeddings, and S3 Vectors to create a fully AWS-native Retrieval-Augmented Generation architecture without managing custom vector databases manually.

A serverless architecture was chosen for the AI assistant because chatbot traffic is intermittent and request durations are short-lived, making Lambda and API Gateway significantly more cost-efficient than continuously running infrastructure.

The frontend UI intentionally avoids generic portfolio templates in favor of a minimal engineering-focused aesthetic inspired by modern infrastructure and AI platforms.

---

# Challenges

* Debugging Route53 and CloudFront DNS propagation
* Configuring CloudFront with private S3 bucket access using OAC
* Setting up GitHub OIDC federation with IAM roles
* Managing CloudFront cache invalidation behavior
* Fixing CI/CD deployment permissions and IAM policy scopes
* Handling Vite production build behavior
* Designing a responsive monochrome UI without sacrificing readability
* Structuring frontend sections to balance technical depth and visual simplicity
* Resolving CORS issues between frontend and serverless backend
* Debugging API Gateway and Lambda response formatting
* Managing Terraform state drift and existing AWS resources
* Configuring Bedrock Knowledge Base retrieval workflows
* Debugging Bedrock model invocation through Lambda
* Ensuring grounded AI responses from portfolio documents instead of generic outputs

One of the biggest deployment lessons came from debugging production CloudFront, API Gateway, Lambda, Terraform, and frontend integration issues simultaneously while ensuring the RAG assistant remained grounded in custom portfolio knowledge.

---

# Final Outcome

The project successfully deployed a live production portfolio website using a fully automated AWS deployment pipeline. Any push to the GitHub repository automatically builds the React application, deploys assets to S3, invalidates CloudFront cache, and updates the live production website globally.

The deployed platform now acts as:

* a professional portfolio website
* a cloud engineering showcase
* a CI/CD deployment demonstration
* a serverless AI platform
* a production-grade frontend hosting architecture
* an AI-powered portfolio knowledge assistant

The integrated RAG assistant allows visitors to ask questions about projects, certifications, AWS deployments, AI systems, and technical background using grounded retrieval from custom knowledge base documents powered entirely through AWS-native GenAI services.

---

## Live Website

[shubhamjoshi.xyz](https://shubhamjoshi.xyz)

---

## GitHub Repository

[Cloud Portfolio Repository](https://github.com/shubhamjoshi1303)

---

# Interview Pitch

I built and deployed a production-grade cloud-hosted portfolio platform using React, Amazon S3, CloudFront, Route53, Terraform, GitHub Actions, and secure AWS deployment practices. The focus of the project was not just frontend development, but designing a real cloud-native deployment architecture and CI/CD pipeline.

I configured private S3 hosting behind CloudFront using Origin Access Control, implemented automated deployment workflows using GitHub Actions and GitHub OIDC federation, and configured HTTPS delivery through ACM and Route53.

I also integrated a serverless RAG-based portfolio assistant using Amazon Bedrock, Bedrock Knowledge Bases, Titan Embeddings, S3 Vectors, Lambda, API Gateway, and application layer Guardrails. The assistant retrieves grounded information from my portfolio knowledge base and answers questions about projects, AWS deployments, and technical experience.

One of the biggest learning experiences came from debugging real-world production deployment issues involving CloudFront, API Gateway, Lambda, Terraform, Vite frontend builds, DNS propagation, and Bedrock retrieval pipelines while ensuring the AI assistant remained grounded in portfolio-specific knowledge instead of generating generic responses.