````md id="dv5n8m"
# What is Node2Vec?

## Overview

Node2Vec is a graph embedding algorithm that converts nodes in a graph into dense numerical vector representations while preserving structural and relational information from the graph.

It allows machine learning systems to represent graph entities such as:

* users
* movies
* products
* social network profiles
* webpages
* knowledge graph entities

as embeddings that capture relationships and graph structure.

Node2Vec is widely used in:

* recommendation systems
* social network analysis
* fraud detection
* graph machine learning
* knowledge graphs
* link prediction
* node classification

---

# Why Node2Vec Matters

Traditional machine learning models work well with:

* tabular data
* images
* text

but graphs are fundamentally different because relationships between nodes are extremely important.

Example graph relationships:

```text id="3h2g5f"
Movie → Actor
Movie → Director
Movie → Genre
User → Product
Person → Friend
````

Node2Vec allows machine learning systems to learn these relationships numerically.

---

# What Node2Vec Actually Does

Node2Vec learns embeddings such that:

```text id="g5r1a9"
nodes with similar graph neighborhoods
                  ↓
receive similar embeddings
```

This means:

* related nodes become closer together in vector space,
* unrelated nodes become farther apart.

---

# High-Level Node2Vec Flow

```text id="xwtmdk"
Graph
   ↓
Random Walk Sampling
   ↓
Node Sequences
   ↓
Skip-Gram Training
   ↓
Node Embeddings
   ↓
Similarity / ML Tasks
```

---

# Node2Vec in This Portfolio Project

Node2Vec was used in the:

```text id="6h4vno"
Graph-Based Movie Recommender System
```

project.

The system used:

* Neo4j Knowledge Graphs
* Node2Vec embeddings
* cosine similarity

to generate personalized movie recommendations.

---

# Movie Knowledge Graph Structure

The graph contained relationships between:

* movies
* actors
* directors
* genres

Example:

```text id="yphc9x"
Interstellar
    ↓
Christopher Nolan
    ↓
Sci-Fi
    ↓
Matthew McConaughey
```

Movies connected through similar graph relationships become semantically closer inside embedding space.

---

# Why Graphs Were Used

Traditional recommendation systems often rely on:

* user ratings
* collaborative filtering
* simple metadata matching

Graphs were chosen because they capture richer relationships between entities.

Example:

```text id="l6m40w"
Movie ↔ Actor
Movie ↔ Director
Movie ↔ Genre
Movie ↔ Keywords
```

This allows recommendations based on structural similarity instead of only ratings.

---

# Random Walks

Node2Vec learns graph structure using:

```text id="g65j7k"
random walks
```

A random walk moves from node to node across graph connections.

Example walk:

```text id="gmqeqr"
Interstellar
   ↓
Christopher Nolan
   ↓
Inception
   ↓
Leonardo DiCaprio
```

These walks create sequences similar to sentences in natural language processing.

---

# Skip-Gram Training

After generating random walks, Node2Vec trains embeddings using a Skip-Gram model similar to Word2Vec.

The model learns:

```text id="nqk9l4"
nodes appearing in similar graph contexts
                  ↓
should have similar embeddings
```

This allows structural graph patterns to be encoded numerically.

---

# Node2Vec Architecture in This Project

```text id="6ll2zt"
IMDb Dataset
      ↓
Neo4j Knowledge Graph
      ↓
Node2Vec Random Walks
      ↓
Embedding Generation
      ↓
128-Dimensional Node Embeddings
      ↓
Cosine Similarity
      ↓
Movie Recommendations
```

---

# Embedding Dimensions

The recommender system generated:

```text id="nv3izw"
128-dimensional embeddings
```

for over:

```text id="q9vdcj"
160K+ graph nodes
```

using Neo4j Graph Data Science (GDS).

---

# Why Embeddings Are Important

The embeddings allow the system to mathematically compare movies.

Movies with similar embeddings are considered structurally similar inside the graph.

This enables semantic recommendations.

---

# Cosine Similarity

After generating embeddings, movie similarity was computed using:

```text id="ev8m0n"
cosine similarity
```

Movies with higher cosine similarity scores are considered more related.

---

# Example Recommendation Logic

If a user likes:

```text id="eqcx7n"
Interstellar
```

the system may recommend:

```text id="7qjjlwm"
Inception
The Prestige
Blade Runner 2049
```

because:

* they share graph relationships,
* directors,
* themes,
* genres,
* actors,
* structural graph neighborhoods.

---

# Why Node2Vec Is Powerful

Node2Vec captures:

* structural similarity
* neighborhood similarity
* graph connectivity
* hidden relationships

without requiring manually engineered features.

---

# Node2Vec vs Traditional Recommendation Systems

## Traditional Collaborative Filtering

Uses:

* ratings
* user behavior
* interaction history

Problems:

* cold start problem
* sparse data
* weak structural understanding

---

## Node2Vec Graph Embeddings

Uses:

* graph structure
* relationships
* neighborhoods
* entity connectivity

Benefits:

* richer semantic understanding
* better relationship modeling
* graph-aware recommendations

---

# Why Node2Vec Was Chosen for This Project

Node2Vec was selected because:

* IMDb data naturally forms a graph structure,
* relationships between entities are extremely important,
* embeddings enable scalable similarity search,
* graph-based similarity produces more meaningful recommendations.

It also integrates well with:

* Neo4j
* Graph Data Science
* cosine similarity retrieval workflows

---

# Deployment Architecture of the Movie Recommender

```text id="y0x2qf"
IMDb Data
      ↓
Preprocessing (Pandas/Dask)
      ↓
Neo4j Graph Database
      ↓
Node2Vec Embeddings
      ↓
FastAPI Backend
      ↓
Docker Container
      ↓
AWS EC2 Deployment
      ↓
React Frontend
      ↓
CloudFront + S3
```

---

# Challenges Faced During the Project

Several engineering and ML challenges were encountered:

## Large Dataset Processing

The IMDb dataset exceeded:

```text id="dbgbp6"
7.5GB
```

requiring:

* chunking
* memory optimization
* Dask-based preprocessing

---

## Graph Construction

Challenges included:

* relationship mapping
* graph consistency
* data cleaning
* node duplication handling

---

## Embedding Generation

Generating embeddings for large graphs required:

* efficient graph traversal
* tuning random walk parameters
* dimensionality tuning
* similarity optimization

---

## Deployment Challenges

Production deployment involved:

* Docker containerization
* EC2 setup
* Nginx reverse proxy
* HTTPS configuration
* CORS debugging
* CloudFront integration

---

# Real-World Uses of Node2Vec

Node2Vec and graph embeddings are widely used in:

* recommendation systems
* LinkedIn-style connection recommendations
* fraud detection
* social network analysis
* knowledge graphs
* cybersecurity
* product recommendation systems
* search ranking systems

---

# Node2Vec vs Graph Neural Networks (GNNs)

## Node2Vec

* embedding-based
* random walk driven
* lightweight
* efficient
* simpler deployment

---

## Graph Neural Networks

* deep learning based
* more powerful
* computationally expensive
* more complex training pipelines

Node2Vec was chosen here because:

* it was computationally efficient,
* scalable,
* easier to deploy,
* and effective for recommendation tasks.

---

# Why Node2Vec Matters in Modern AI Systems

Modern recommendation systems increasingly rely on:

* embeddings
* graph relationships
* semantic similarity

instead of only:

* ratings
* keyword matching
* metadata filtering

Node2Vec is one of the foundational graph embedding techniques enabling this shift.

---

# Skills Demonstrated Through This Project

This project demonstrates practical experience with:

* Node2Vec
* graph embeddings
* Neo4j
* Graph Data Science
* cosine similarity
* graph machine learning
* recommendation systems
* embedding generation
* semantic similarity
* graph databases
* Dask
* FastAPI
* Docker
* AWS deployment
* graph-based retrieval systems

```
```
