````md id="j8m2vc"
# What is Shor’s Algorithm?

## Overview

Shor’s Algorithm is a quantum computing algorithm developed by Peter Shor in 1994 for efficiently factoring large integers.

It is considered one of the most important quantum algorithms because it demonstrated that quantum computers could theoretically solve certain problems exponentially faster than classical computers.

Shor’s Algorithm is especially important because it can break widely used public-key cryptographic systems such as:

* RSA encryption
* integer factorization-based cryptography

This discovery became one of the major reasons quantum computing gained global research attention.

---

# Why Shor’s Algorithm Matters

Modern internet security heavily relies on the fact that:

```text id="e8c5si"
factoring very large numbers
          ↓
is computationally difficult
````

for classical computers.

RSA encryption depends on this assumption.

For sufficiently large integers:

* classical factorization becomes extremely slow,
* but Shor’s Algorithm can theoretically solve it efficiently using quantum computation.

This means large-scale fault-tolerant quantum computers could potentially break RSA encryption in the future.

---

# The Core Problem

Given:

```text id="3gh1p3"
N = p × q
```

where:

* `p`
* `q`

are prime numbers,

the goal is to determine the prime factors of `N`.

For large values of `N`, this is computationally expensive classically.

---

# Classical vs Quantum Complexity

## Classical Factorization

Classical factorization algorithms become extremely slow for large integers.

Factoring large RSA keys can take:

* enormous computational power,
* extremely long runtimes.

---

## Quantum Factorization

Shor’s Algorithm provides a polynomial-time quantum solution.

This creates an exponential speedup compared to many classical approaches.

---

# High-Level Idea Behind Shor’s Algorithm

Shor’s Algorithm transforms integer factorization into a:

```text id="h9mxlo"
period finding problem
```

Quantum computers are very efficient at solving period-finding problems using:

* quantum superposition
* interference
* Quantum Fourier Transform (QFT)

---

# High-Level Shor’s Algorithm Flow

```text id="jlwm0x"
Choose Random Integer
         ↓
Modular Arithmetic Function
         ↓
Quantum Superposition
         ↓
Quantum Fourier Transform (QFT)
         ↓
Period Detection
         ↓
Classical Post-Processing
         ↓
Prime Factors
```

---

# Key Concepts Used in Shor’s Algorithm

## 1. Quantum Superposition

Quantum bits (qubits) can exist in multiple states simultaneously.

Instead of being only:

```text id="5y6x5k"
0 or 1
```

a qubit can represent:

* 0,
* 1,
* or both simultaneously.

This allows quantum computers to process many possibilities at once.

---

# 2. Quantum Interference

Quantum amplitudes can interfere constructively or destructively.

This allows quantum algorithms to:

* amplify correct answers,
* suppress incorrect answers.

---

# 3. Quantum Fourier Transform (QFT)

The Quantum Fourier Transform is a quantum analogue of the classical Fourier Transform.

QFT is used to extract periodic patterns from quantum states efficiently.

In Shor’s Algorithm:

* QFT helps identify the period of a modular arithmetic function.

---

# 4. Period Finding

The most important step in Shor’s Algorithm is finding the period:

```text id="r9jv7d"
f(x) = a^x mod N
```

The algorithm finds a repeating cycle (period) within this function.

Once the period is found, classical mathematics can often derive the factors of `N`.

---

# Why Period Finding Helps Factorization

If the period:

```text id="5r1p4d"
r
```

is known, then mathematical properties can be used to compute:

```text id="byjlwm"
gcd(a^(r/2) ± 1, N)
```

which may reveal the prime factors of `N`.

This combines:

* quantum computation,
* classical number theory,
* modular arithmetic.

---

# Shor’s Algorithm in This Portfolio Project

This project focused on:

* simulating Shor’s Algorithm,
* understanding quantum factorization,
* building quantum circuits using Qiskit,
* visualizing quantum measurement behavior.

Because practical fault-tolerant quantum hardware is still limited, the algorithm was simulated on classical systems using quantum simulation frameworks.

---

# Technologies Used

The project used:

* Python
* Qiskit
* NumPy
* matplotlib

to build and simulate quantum circuits.

---

# High-Level Project Architecture

```text id="ybjlwm"
Classical Input Integer
          ↓
Quantum Circuit Construction
          ↓
Quantum Superposition
          ↓
Quantum Fourier Transform
          ↓
Quantum Measurement
          ↓
Period Estimation
          ↓
Classical GCD Computation
          ↓
Integer Factorization
```

---

# Quantum Circuit Components

The implementation included:

* Hadamard gates
* controlled operations
* modular exponentiation
* QFT circuits
* measurement operations

These components simulate the quantum computation workflow used in Shor’s Algorithm.

---

# Why Qiskit Was Used

Qiskit was chosen because:

* it is one of the most widely used quantum computing frameworks,
* it provides quantum circuit simulation,
* it integrates well with educational quantum workflows,
* it allows experimentation without physical quantum hardware.

---

# Challenges Faced During the Project

Several challenges were encountered:

## Quantum Computing Complexity

Understanding:

* superposition,
* interference,
* QFT,
* modular arithmetic,
* period finding

required strong mathematical foundations.

---

## Quantum Simulation Constraints

Because the project used classical simulation:

* qubit count was limited,
* simulation performance became expensive at scale,
* practical large-number factorization was not feasible.

---

## Quantum Circuit Design

Building correct:

* QFT circuits,
* modular exponentiation logic,
* controlled gate operations

required careful debugging and mathematical validation.

---

# Why Shor’s Algorithm Is Important Historically

Shor’s Algorithm was historically significant because it showed:

```text id="jlwmr0"
quantum computers can solve certain problems
dramatically faster than classical computers
```

This changed:

* cryptography research,
* security research,
* theoretical computer science,
* quantum hardware development.

---

# Shor’s Algorithm and RSA Encryption

RSA security depends on:

* classical factorization difficulty.

If large-scale fault-tolerant quantum computers become practical:

* RSA encryption could potentially be broken using Shor’s Algorithm.

This is why:

* post-quantum cryptography,
* quantum-safe encryption

have become major research areas.

---

# Real-World Uses of Quantum Computing

Quantum computing research today explores:

* cryptography
* optimization
* molecular simulation
* materials science
* logistics
* AI acceleration
* finance
* quantum chemistry

Although practical large-scale quantum systems are still developing, the field is growing rapidly.

---

# Shor’s Algorithm vs Classical Algorithms

| Feature              | Classical Factorization           | Shor’s Algorithm            |
| -------------------- | --------------------------------- | --------------------------- |
| Compute Model        | Classical                         | Quantum                     |
| Scaling              | Extremely slow for large integers | Polynomial-time             |
| Parallelism          | Limited                           | Quantum superposition       |
| Cryptographic Impact | Secure RSA                        | Can theoretically break RSA |

---

# Why This Project Matters

This project demonstrates understanding of:

* quantum computing fundamentals
* quantum algorithms
* mathematical foundations of cryptography
* Qiskit
* quantum circuit simulation
* hybrid quantum-classical workflows

It also demonstrates the ability to learn highly theoretical computer science topics and implement them programmatically.

---

# Real-World Engineering Skills Demonstrated

This project demonstrates practical experience with:

* Qiskit
* quantum circuits
* quantum algorithms
* modular arithmetic
* Quantum Fourier Transform
* scientific computing
* Python simulation workflows
* algorithm visualization
* computational mathematics
* cryptography concepts
* research-style engineering projects

```
```
