````md id="h4q2zn"
# Cloud Resume Challenge – AWS Serverless Portfolio Platform

## Short Summary

This project is a fully serverless cloud-native portfolio platform built on AWS and deployed using Infrastructure-as-Code principles. The application combines a React frontend hosted on Amazon S3 and CloudFront with a serverless backend powered by AWS Lambda, API Gateway, and DynamoDB. The project was designed to showcase production-grade AWS architecture, CI/CD automation, Terraform-based infrastructure provisioning, and modern frontend deployment practices.

The platform includes a live visitor tracking API, automated GitHub Actions deployment pipeline using OpenID Connect (OIDC), custom domain integration through Route53 and ACM, and a globally distributed CloudFront CDN layer. The project emphasizes real-world cloud engineering concepts including secure CI/CD authentication, infrastructure automation, remote Terraform state management, and debugging distributed cloud systems.

---

# Problem

Traditional resume websites are static and do not effectively demonstrate practical cloud engineering skills or real deployment experience. This project solves that problem by transforming a personal portfolio into a production-style cloud platform with automated deployments, serverless APIs, infrastructure-as-code, and AWS-native architecture.

The goal was not simply to host a frontend website, but to demonstrate how modern cloud applications are designed, deployed, secured, and maintained using AWS best practices and DevOps workflows.

---

# Architecture

```text
React + Vite Frontend
        ↓
Amazon S3 (Private Bucket)
        ↓
CloudFront CDN + OAC
        ↓
Route53 Custom Domain + ACM HTTPS
        ↓
GitHub Actions CI/CD
        ↓
OIDC Federation to AWS IAM
        ↓
Terraform Infrastructure
```

---

## Visitor Counter Flow

```text
Frontend
   ↓
API Gateway HTTP API
   ↓
AWS Lambda (Python)
   ↓
DynamoDB
```

---

Terraform manages the full infrastructure lifecycle including:

* S3
* CloudFront
* IAM
* API Gateway
* Lambda
* DynamoDB
* GitHub OIDC provider
* Route53 integration

---

# My Role

I designed, deployed, and debugged the entire cloud infrastructure and frontend deployment pipeline. I implemented the Terraform infrastructure modules, configured the serverless backend architecture, integrated the React frontend with the visitor counter API, and set up GitHub Actions CI/CD using OIDC federation instead of long-lived AWS credentials.

I also handled production debugging tasks including:

* CloudFront deployment behavior
* GitHub Actions workflow failures
* Terraform provider imports
* Vite environment variable injection
* API Gateway and Lambda integration
* CloudFront cache invalidation
* repository restructuring issues
* frontend/backend deployment synchronization

---

# Tech Stack

## AWS Services

* Amazon S3
* Amazon CloudFront
* AWS Lambda
* Amazon API Gateway (HTTP API v2)
* Amazon DynamoDB
* AWS IAM
* AWS Certificate Manager (ACM)
* Amazon Route53
* Amazon CloudWatch

---

## Frontend / Backend

* React
* Vite
* Tailwind CSS
* Python
* boto3

---

## Infrastructure / DevOps

* Terraform
* GitHub Actions
* GitHub OIDC Federation
* Remote Terraform S3 Backend

---

# Key Features

* Fully serverless AWS architecture
* HTTPS-enabled custom domain deployment
* Automated CI/CD deployment pipeline
* Secure GitHub OIDC authentication without AWS access keys
* Infrastructure-as-Code using Terraform modules
* Visitor tracking API using Lambda + DynamoDB
* CloudFront CDN integration with Origin Access Control (OAC)
* Private S3 bucket architecture
* Automated CloudFront cache invalidation on deployment
* Production-ready frontend deployment workflow
* Responsive React portfolio frontend

---

# Important Design Decisions

I chose a serverless architecture because the application workload is lightweight and event-driven. Using Lambda and API Gateway removed the need for managing always-running infrastructure while significantly reducing operational complexity and cost.

CloudFront with Origin Access Control (OAC) was selected instead of public S3 website hosting to improve security and follow modern AWS best practices for private bucket access.

Terraform was used to ensure reproducible infrastructure provisioning and modular infrastructure design. Remote Terraform state management was implemented using Amazon S3.

GitHub Actions OIDC federation was implemented instead of long-lived AWS IAM credentials to improve CI/CD security and follow modern cloud authentication practices.

---

# Challenges

* Debugging GitHub Actions OIDC authentication issues
* Importing pre-existing IAM OIDC providers into Terraform state
* Handling repository restructuring and broken workflow paths
* Resolving frontend environment variable injection problems with Vite
* Managing CloudFront invalidation timing and deployment consistency
* Debugging API Gateway HTTP API integrations
* Configuring secure private S3 bucket access using OAC
* Handling Terraform provider initialization and remote backend configuration
* Resolving React StrictMode visitor counter double invocation behavior
* Fixing frontend/backend synchronization during production deployments

---

# Final Outcome

The project successfully deployed a production-ready cloud-native resume platform accessible through a custom domain with automated CI/CD deployment capabilities. The infrastructure is fully reproducible using Terraform and demonstrates real-world AWS cloud engineering practices across networking, serverless architecture, infrastructure automation, frontend deployment, and DevOps workflows.

The project also established reusable Terraform modules and deployment workflows that can be extended for future multi-environment or production-scale deployments.

---

## Live Platform

[resume.shubhamjoshi.xyz](https://resume.shubhamjoshi.xyz/)

---

# Interview Pitch

I built a fully serverless cloud-native portfolio platform on AWS using React, Terraform, Lambda, API Gateway, DynamoDB, CloudFront, and GitHub Actions CI/CD. The goal of the project was to demonstrate production-level cloud engineering practices rather than simply hosting a static website.

I designed the infrastructure using modular Terraform, deployed the frontend through S3 and CloudFront with Origin Access Control, implemented a serverless visitor tracking API using Lambda and DynamoDB, and configured secure GitHub Actions deployments using OIDC federation instead of long-lived AWS credentials.

One of the biggest learning experiences from the project was debugging real-world cloud deployment issues including Terraform state imports, GitHub Actions workflow failures, CloudFront deployment behavior, Vite environment variable injection, and API Gateway integrations. The project gave me hands-on experience with modern AWS deployment workflows, infrastructure automation, and production debugging practices.
````
