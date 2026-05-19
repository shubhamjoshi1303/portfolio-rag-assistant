````md id="p1x8sw"
# CloudCart — Cloud-Native E-Commerce Platform

## Short Summary

CloudCart is a full-stack cloud-native e-commerce platform built using React, FastAPI, Docker, and AWS cloud infrastructure services. The project was designed to simulate a real-world scalable commerce application using production-style deployment patterns, distributed cloud infrastructure, secure authentication, container orchestration, and globally distributed frontend hosting.

The platform integrates Amazon ECS Fargate, API Gateway, Cognito authentication, Application Load Balancer (ALB), VPC networking, RDS, DynamoDB, S3, CloudFront, and Route 53 into a unified architecture. The frontend was redesigned into a premium SaaS-inspired interface influenced by platforms such as Linear, Vercel, and Apple, while the backend demonstrates scalable microservice deployment and cloud-native engineering concepts.

Unlike traditional tutorial-style e-commerce projects, this application emphasizes infrastructure ownership, deployment architecture, secure cloud networking, and real production workflows.

---

# Problem

Most beginner e-commerce projects focus only on frontend functionality or simple backend CRUD APIs running locally. They rarely demonstrate:

* scalable cloud deployment
* secure authentication systems
* container orchestration
* production networking architecture
* API routing
* CDN delivery
* infrastructure scalability
* cloud-native backend deployment

This project solves that problem by implementing a fully deployed distributed commerce platform using real AWS infrastructure services and production deployment practices.

The goal was to create an application that demonstrates both software engineering and cloud engineering skills while simulating how modern scalable commerce systems are architected in production environments.

---

# Architecture

```text
User
   ↓
Route 53
   ↓
CloudFront CDN
   ↓
S3 React Frontend
```

---

## Authentication Flow

```text
Frontend
   ↓
Amazon Cognito
   ↓
JWT Authentication
   ↓
Protected API Access
```

---

## Backend Architecture

```text
Frontend
   ↓
API Gateway
   ↓
VPC Link
   ↓
Application Load Balancer (ALB)
   ↓
Amazon ECS Fargate Cluster
```

---

## Microservices Running on ECS

* Product Service
* Cart Service
* User Service
* Order Service

---

## Database Layer

```text
Product / Cart Services
      ↓
DynamoDB

User / Order Services
      ↓
Amazon RDS PostgreSQL
```

---

## Infrastructure Components

* Custom VPC
* Public & Private Subnets
* NAT Gateway
* Security Groups
* IAM Roles
* CloudWatch Monitoring

---

## Future Scope

```text
Order Placement
      ↓
SNS Notifications
      ↓
SES Email Notifications
```

---

# My Role

I designed, deployed, and integrated the complete frontend and cloud infrastructure architecture for the application.

I personally implemented:

* React frontend application
* Modern SaaS-inspired UI redesign
* Cognito authentication integration
* API Gateway routing
* ECS Fargate deployment
* ALB integration
* VPC networking configuration
* Route 53 domain setup
* CloudFront CDN delivery
* S3 frontend hosting
* Docker container deployment workflow
* Cart and order management frontend flows
* Production deployment pipeline
* Custom domain HTTPS hosting

I also redesigned the frontend from a basic ecommerce template into a premium dark-themed cloud-native application showcasing modern UI engineering and AWS infrastructure concepts.

---

# Tech Stack

## AWS Services

* Amazon ECS Fargate
* Amazon API Gateway
* Amazon Cognito
* Amazon RDS PostgreSQL
* Amazon DynamoDB
* Amazon S3
* Amazon CloudFront
* Route 53
* Application Load Balancer (ALB)
* VPC
* NAT Gateway
* IAM
* CloudWatch

---

## Frontend

* React
* JavaScript
* CSS

---

## Backend

* FastAPI
* Python
* REST APIs

---

## DevOps / Infrastructure

* Docker
* ECS Container Deployment
* CloudFront CDN
* Custom VPC Networking

---

## Databases

* DynamoDB
* PostgreSQL (Amazon RDS)

---

# Key Features

* Cloud-native e-commerce architecture
* Secure authentication using Amazon Cognito
* JWT-protected APIs
* Product catalog system
* Shopping cart functionality
* Persistent order management
* Order history tracking
* Distributed backend microservices
* Containerized backend deployment
* Global frontend delivery using CloudFront
* Custom domain HTTPS hosting
* Modern responsive SaaS-style UI
* VPC-isolated backend infrastructure
* Load-balanced backend services using ALB

---

# Important Design Decisions

I chose ECS Fargate instead of traditional EC2 deployment because I wanted to demonstrate container orchestration and serverless container infrastructure without manually managing servers.

The backend was separated into four microservices (Product, Cart, User, and Order services) to simulate real distributed commerce architecture and improve scalability and service isolation.

API Gateway combined with VPC Link and an Application Load Balancer was used to simulate enterprise-style API routing and secure private backend access inside the VPC.

CloudFront and S3 were selected for frontend hosting to provide globally distributed low-latency content delivery while showcasing CDN architecture concepts.

Cognito was used instead of a custom authentication implementation to demonstrate managed identity and authentication services commonly used in production systems.

The frontend redesign intentionally adopted a premium dark SaaS aesthetic inspired by Linear and Vercel to make the project feel closer to a real modern cloud platform rather than a tutorial project.

---

# Challenges

* Configuring Cognito authentication flows correctly
* Handling JWT authentication between frontend and backend
* ECS Fargate deployment troubleshooting
* Managing ALB routing with API Gateway
* Configuring VPC networking and security groups
* Debugging frontend-to-backend connectivity
* CloudFront cache invalidation issues
* React production build deployment to S3
* Managing Docker container consistency
* Designing a scalable frontend architecture
* Coordinating frontend deployment with backend infrastructure
* Debugging image delivery and CDN caching behavior

---

# Final Outcome

The project successfully deployed a fully functional cloud-native e-commerce platform with production frontend hosting, secure authentication, distributed backend services, and scalable AWS infrastructure.

The platform now demonstrates:

* cloud-native architecture understanding
* distributed microservice deployment
* AWS infrastructure design
* frontend engineering skills
* containerized backend deployment
* CDN delivery systems
* secure authentication integration
* production deployment workflows

The application includes fully working:

* signup/login flows
* product browsing
* cart management
* order placement
* order history tracking
* persistent backend integration

---

## Live Demo

[shop.shubhamjoshi.xyz](https://shop.shubhamjoshi.xyz/)

---

## GitHub Repository

[CloudCart Repository](https://github.com/shubhamjoshi1303/ecommerce-aws)

---

# Interview Pitch

I built and deployed a production-style cloud-native e-commerce platform using React, FastAPI, Docker, Amazon ECS Fargate, API Gateway, Cognito, ALB, DynamoDB, PostgreSQL, S3, CloudFront, and Route 53.

The primary goal of the project was not just building an online store, but designing a scalable distributed cloud application using modern AWS infrastructure practices.

I implemented a microservice-style backend architecture running on ECS Fargate with four separate services for products, carts, users, and orders. The backend services were deployed inside a custom VPC behind an Application Load Balancer and exposed securely through API Gateway using VPC Link integration.

On the frontend side, I redesigned the UI into a premium SaaS-inspired interface and deployed it globally using S3 and CloudFront with custom domain hosting.

The project helped me gain hands-on experience with container orchestration, API routing, cloud networking, CDN delivery, authentication systems, distributed backend architecture, and production AWS deployment workflows.

As future scope, I also plan to integrate SNS and SES for automated order confirmation and notification workflows.
````
