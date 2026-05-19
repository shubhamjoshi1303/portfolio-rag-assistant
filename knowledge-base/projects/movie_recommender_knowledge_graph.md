# Graph-Based Movie Recommender System

## Short Summary

This project is a graph-based movie recommendation platform built using Neo4j knowledge graphs, Node2Vec embeddings, FastAPI, React, Docker, and AWS cloud infrastructure. The system began as a research project focused on transforming the IMDb dataset into a knowledge graph connecting movies, actors, directors, and genres, then generating graph embeddings using Node2Vec to power personalized movie recommendations.

The project was later extended into a fully deployed production-style cloud application hosted on AWS. The final system includes a React frontend hosted through Amazon S3 and CloudFront, a Dockerized FastAPI backend deployed on EC2 behind Nginx with HTTPS, and a live recommendation engine capable of multi-movie embedding averaging and cosine similarity search. The deployment involved real-world cloud engineering practices including Docker orchestration, reverse proxy configuration, Route53 DNS management, SSL setup, CloudFront CDN integration, environment configuration, and CORS debugging between distributed frontend and backend services.

---

# Problem

Traditional recommendation systems often rely on collaborative filtering or simple metadata filtering, which can miss deeper structural relationships between movies. The goal of this project was to build a recommendation system capable of understanding graph relationships between movies through actors, directors, genres, and graph connectivity rather than relying purely on ratings or user behavior.

Another goal was to convert the research implementation into a real-world production deployment capable of serving live recommendations through a cloud-hosted web application using modern frontend, backend, containerization, and AWS deployment workflows.

---

# Architecture

```text
IMDb Dataset
    ↓
Neo4j Knowledge Graph
    ↓
Node2Vec Embedding Generation
    ↓
Cosine Similarity Engine
    ↓
FastAPI Backend
    ↓
Docker Container
    ↓
Nginx Reverse Proxy + HTTPS
    ↓
EC2 Instance
    ↓
React Frontend (Vite)
    ↓
Amazon S3
    ↓
CloudFront CDN + Route53
```

The recommendation engine uses Neo4j Graph Data Science (GDS) to generate embeddings from graph relationships and exports them into vector representations for inference. The deployed version exposes the recommendation system through FastAPI REST APIs consumed by the React frontend.

The production cloud architecture includes:

* React frontend hosted in Amazon S3
* CloudFront CDN with HTTPS delivery
* Route53 custom domain integration
* Dockerized FastAPI backend
* EC2 deployment in a public subnet
* Nginx reverse proxy for SSL termination
* Let’s Encrypt HTTPS certificates
* CORS-managed frontend/backend communication

---

# My Role

I designed and implemented the complete system end-to-end, including both the graph machine learning pipeline and the deployed cloud infrastructure.

For the recommendation engine and graph pipeline, I:

* Processed and cleaned large IMDb datasets (~7.5GB raw data)
* Built a Neo4j knowledge graph connecting movies, actors, genres, and directors
* Generated Node2Vec embeddings using Neo4j Graph Data Science
* Implemented cosine similarity-based recommendation logic
* Built multi-movie embedding averaging for personalized recommendations
* Evaluated recommendations across multiple genres and datasets
* Wrote and published a research-style paper documenting the methodology and evaluation results

For the deployed production application, I:

* Built the React + Vite frontend interface
* Containerized the FastAPI backend using Docker
* Configured EC2 deployment infrastructure
* Implemented HTTPS using Nginx and Certbot
* Configured Route53 DNS records and custom domains
* Deployed frontend assets through S3 + CloudFront
* Debugged production CORS and HTTPS mixed-content issues
* Configured frontend production environment variables
* Managed CloudFront caching and invalidation workflows

---

# Tech Stack

## AWS Services

* Amazon EC2
* Amazon S3
* Amazon CloudFront
* Amazon Route53
* AWS Certificate Manager (frontend HTTPS)
* Amazon VPC

---

## Frontend / Backend

* React
* Vite
* FastAPI
* Python
* Nginx
* Docker

---

## Data Science / Graph / ML

* Neo4j
* Neo4j Graph Data Science (GDS)
* Node2Vec
* scikit-learn
* cosine similarity
* pandas
* dask

---

## Data Source

* IMDb dataset

---

# Key Features

* Personalized graph-based movie recommendations
* Multi-movie recommendation generation using averaged embeddings
* Knowledge graph modeling of actors, genres, directors, and movies
* Node2Vec graph embeddings for structural similarity
* Cosine similarity ranking engine
* FastAPI REST recommendation API
* Real-time frontend recommendation interface
* Interactive movie search and selection
* IMDb and trailer quick-search links
* Research paper integration directly into the deployed application
* Production cloud deployment with HTTPS and CDN acceleration

---

# Important Design Decisions

I chose a graph-based recommendation architecture because knowledge graphs preserve relationships between entities more effectively than traditional relational or collaborative filtering systems. By representing actors, genres, directors, and movies as connected nodes, the recommender could identify deeper structural similarities between films.

Node2Vec was selected because it captures both local and global graph structure through biased random walks and embedding generation, enabling movies with similar neighborhoods to occupy nearby positions in vector space.

For deployment, I intentionally chose a lightweight production architecture:

* EC2 instead of ECS to reduce operational complexity for a portfolio-scale deployment
* Docker for reproducible backend deployment
* Nginx reverse proxy for HTTPS termination and backend routing
* CloudFront + S3 for globally distributed static frontend hosting
* Route53 custom subdomains for production-grade URLs

I also chose to store embeddings locally instead of using a vector database because inference latency and dataset size were manageable directly in-memory.

---

# Challenges

* Processing and cleaning large IMDb datasets (~7.5GB raw data)
* Optimizing Neo4j graph construction and batch relationship creation
* Managing Node2Vec embedding generation on large graphs
* Handling multi-movie embedding averaging logic
* Configuring Docker deployment across ARM/x86 environments
* Debugging EC2 SSH and security group configuration
* Configuring HTTPS using Nginx and Certbot
* Resolving HTTPS frontend → HTTP backend mixed-content errors
* Debugging CORS failures between CloudFront frontend and FastAPI backend
* Managing frontend environment variables during Vite production builds
* Configuring CloudFront + private S3 deployment correctly using OAC
* Handling frontend cache invalidation after deployments

One of the most important debugging lessons came from resolving the production issue where the CloudFront HTTPS frontend could not communicate with the HTTP backend, requiring a full reverse-proxy architecture using Nginx and SSL termination.

---

# Final Outcome

The final system successfully evolved from a graph machine learning research project into a fully deployed production-ready cloud application.

The recommendation engine generates highly relevant graph-aware recommendations. Example outputs from the research evaluation include:

* Interstellar → Oppenheimer, Inception, Tenet
* Spirited Away → My Neighbor Totoro, The Boy and the Heron
* 3 Idiots → PK, Sanju, Munna Bhai M.B.B.S.

The deployed platform now includes:

* Live frontend hosted through CloudFront
* HTTPS-secured API backend
* Interactive recommendation interface
* Research paper integration
* Public GitHub repositories
* Production deployment workflow

Live Demo:

[Graph-Based Movie Recommender Live Demo](https://movie.shubhamjoshi.xyz/)


Research Paper:

[Movie Recommender Research Paper](https://drive.google.com/file/d/1oQvKKb4UmfPnujVUh0Fsl5uJAqxrnat2/view)

GitHub Repositories:

### Original Graph Recommender Research Implementation

[IMDb Movie Recommender Research Implementation](https://github.com/shubhamjoshi1303/Imdb-movie-recommender_design)

### Production Deployment Architecture

[IMDb Recommender Production Deployment](https://github.com/shubhamjoshi1303/imdb_recommender_deployment)

---

# Interview Pitch

I built a graph-based movie recommender system using Neo4j knowledge graphs and Node2Vec embeddings trained on the IMDb dataset. The idea was to model movies, actors, genres, and directors as interconnected graph nodes instead of using traditional recommendation methods like collaborative filtering.

I processed and cleaned roughly 7.5GB of IMDb data, constructed a Neo4j knowledge graph, and used Neo4j Graph Data Science to generate Node2Vec embeddings that captured structural movie relationships. I then used cosine similarity to build a recommendation engine capable of generating highly relevant movie suggestions.

After completing the research implementation and publishing a research-style paper, I extended the project into a production cloud application. I built a React frontend, containerized the FastAPI backend using Docker, deployed the backend on EC2 with Nginx and HTTPS, and hosted the frontend through S3 and CloudFront using Route53 custom domains.

One of the biggest learning experiences came from debugging real-world cloud deployment problems including HTTPS mixed-content errors, CORS failures between CloudFront and FastAPI, Docker deployment issues across ARM/x86 environments, and production environment variable configuration in Vite. The project gave me hands-on experience across graph machine learning, backend engineering, frontend deployment, cloud infrastructure, and production debugging.