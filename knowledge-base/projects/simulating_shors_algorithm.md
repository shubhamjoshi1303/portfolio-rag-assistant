Simulating Shor’s Algorithm

Short Summary

This project is a simplified simulation of Shor’s Algorithm built using Qiskit to demonstrate how quantum computing can theoretically factor composite numbers exponentially faster than classical algorithms. The implementation focuses on the core concepts behind Shor’s Algorithm, including quantum superposition, period finding, Quantum Fourier Transform (QFT), and classical post-processing for factor recovery.

The simulation uses Qiskit Aer to emulate quantum circuit execution locally and demonstrates the factorization of the composite number 15. The project was built as an educational quantum computing project to better understand how quantum algorithms interact with classical computation and why Shor’s Algorithm is considered a major breakthrough in quantum cryptography.

Repository:Simulating Shor’s Algorithm Repository

Problem

Modern encryption systems such as RSA rely on the computational difficulty of factoring large composite numbers using classical computers. Classical factorization becomes increasingly difficult as the size of the numbers grows.

Shor’s Algorithm solves this problem differently by converting integer factorization into a quantum period-finding problem. The objective of this project was to simulate the workflow of Shor’s Algorithm to understand how quantum computing can potentially break classical cryptographic systems by efficiently finding factors of composite numbers.

Architecture

Input Composite Number N
        ↓
Choose Random Coprime x
        ↓
Quantum Circuit Preparation
        ↓
Apply Hadamard Superposition
        ↓
Simplified Modular Exponentiation
        ↓
Quantum Fourier Transform (QFT)
        ↓
Quantum Measurement
        ↓
Period Estimation
        ↓
Classical GCD Computation
        ↓
Recover Non-Trivial Factors

The project combines:

quantum circuit simulation using Qiskit,

Quantum Fourier Transform for period estimation,

and classical mathematical post-processing using GCD and continued fraction approximation.

My Role

I implemented the complete Shor’s Algorithm simulation workflow using Python and Qiskit. I designed the quantum circuit, implemented the superposition step using Hadamard gates, applied a simplified modular exponentiation process, integrated the Quantum Fourier Transform, simulated measurements using Qiskit Aer, and performed classical post-processing to estimate the period and recover the factors.

I also added histogram visualization for the measurement outcomes to better interpret the quantum state probabilities and understand how QFT contributes to period estimation.

Tech Stack

Quantum Computing Tools

Qiskit

Qiskit Aer

QuantumCircuit

Quantum Fourier Transform (QFT)

Programming / Scientific Computing

Python

NumPy

matplotlib

math

fractions

Concepts Used

Quantum Computing

Shor’s Algorithm

Quantum Fourier Transform

Period Finding

Modular Arithmetic

Quantum Circuit Simulation

RSA Factorization Concepts

Key Features

Simulates a simplified version of Shor’s Algorithm

Demonstrates integer factorization using quantum principles

Uses Qiskit to build and simulate quantum circuits

Applies Hadamard gates to generate quantum superposition

Uses Quantum Fourier Transform for period estimation

Performs classical post-processing using GCD calculations

Visualizes quantum measurement outcomes using histograms

Demonstrates hybrid quantum-classical computation workflow

Factors the composite number 15

Important Design Decisions

I chose Qiskit because it provides a practical framework for building and simulating quantum circuits locally without requiring physical quantum hardware access.

The project focuses on factoring the number 15 because it is computationally manageable while still demonstrating the main concepts behind Shor’s Algorithm. The goal of the project was educational understanding rather than production-scale cryptographic attacks.

A simplified modular exponentiation step was intentionally used to keep the implementation understandable while still preserving the overall algorithmic structure:

superposition,

QFT,

measurement,

period estimation,

and classical factor recovery.

Histogram visualizations were added to make quantum measurement outputs easier to interpret and debug.

Challenges

Several conceptual and technical challenges were encountered during development:

Understanding how factorization becomes a period-finding problem

Translating theoretical quantum computing concepts into Qiskit circuits

Implementing and debugging Quantum Fourier Transform workflows

Handling cases where invalid or odd periods were measured

Connecting quantum measurement outputs to classical GCD calculations

Managing probabilistic measurement behavior during simulation

Simplifying modular exponentiation while preserving algorithm flow

Visualizing and interpreting quantum measurement results

One of the biggest learning challenges was understanding how the quantum and classical parts of Shor’s Algorithm work together in a hybrid computational pipeline.

Final Outcome

The final project successfully simulated the core workflow of Shor’s Algorithm using Qiskit. The notebook demonstrated:

quantum circuit creation,

quantum superposition,

Quantum Fourier Transform,

measurement-based period estimation,

and classical factor recovery.

The project significantly improved understanding of:

quantum algorithms,

quantum circuit simulation,

hybrid quantum-classical systems,

and the cryptographic implications of quantum computing.

Repository: https://github.com/shubhamjoshi1303/Simulating-Shors-Algorithm

Interview Pitch

I built a simplified simulation of Shor’s Algorithm using Qiskit to understand how quantum computing can solve integer factorization problems more efficiently than classical algorithms. The project demonstrates how factorization can be converted into a quantum period-finding problem using superposition and the Quantum Fourier Transform.

I implemented the full workflow using Qiskit, including quantum circuit creation, Hadamard-based superposition, a simplified modular exponentiation step, QFT-based period estimation, and classical post-processing using GCD calculations to recover factors.

The project helped me understand how quantum and classical computation work together in hybrid algorithms and gave me hands-on experience with quantum circuit simulation, probabilistic measurement behavior, and quantum algorithm implementation using Python and Qiskit.