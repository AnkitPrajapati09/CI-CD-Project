# Enterprise DevSecOps CI/CD & Infrastructure Automation Platform

A production-style end-to-end DevSecOps project that automates infrastructure provisioning, application build, code quality analysis, artifact management, container security scanning, and Kubernetes deployment on Amazon EKS.

This solution leverages Terraform, Jenkins, Maven, SonarQube, Nexus Repository, Docker, Trivy, Amazon ECR, and Amazon EKS to provide a complete CI/CD and Infrastructure-as-Code (IaC) workflow from source code commit to Kubernetes deployment.

---

## 🚀 Project Overview

### Key Features

- Automated AWS infrastructure provisioning using Terraform
- End-to-end CI/CD pipeline using Jenkins Declarative Pipeline
- Maven-based application build and unit testing
- Static code analysis using Checkstyle and SonarQube
- SonarQube Quality Gate enforcement
- Artifact versioning and storage using Nexus Repository
- Multi-stage Docker image creation and optimization
- Container vulnerability scanning using Trivy
- Secure image publishing to Amazon ECR
- Automated Kubernetes deployments to Amazon EKS
- Rolling updates with rollout verification
- Slack notifications for pipeline visibility
- Troubleshooting and operational support for Jenkins, Kubernetes, and AWS services

---

# 🏗️ Architecture Diagram

```text
                          +----------------+
                          |   Developer    |
                          +----------------+
                                  |
                                  | Git Push
                                  v

                          +---------------+
                          |    GitHub     |
                          +---------------+
                                  |
                               Webhook
                                  |
                                  v

                    +---------------------------+
                    |     Jenkins Pipeline      |
                    +---------------------------+
                                  |
         ----------------------------------------------------
         |                  |                 |             |
         v                  v                 v             v

    +---------+      +------------+     +--------+    +---------+
    | Maven   | ---> | Checkstyle | --> | Sonar  | -> | Nexus   |
    | Build   |      | Analysis   |     | Qube   |    | Repo    |
    +---------+      +------------+     +--------+    +---------+
                                                         |
                                                         v
                                                  +-------------+
                                                  |   Docker    |
                                                  | Multi-Stage |
                                                  |    Build    |
                                                  +-------------+
                                                         |
                                                         v
                                                  +-------------+
                                                  |    Trivy    |
                                                  | Security    |
                                                  |   Scan      |
                                                  +-------------+
                                                         |
                                                         v
                                                  +-------------+
                                                  | Amazon ECR  |
                                                  +-------------+
                                                         |
                                                         v
                                                  +-------------+
                                                  | Amazon EKS  |
                                                  | Kubernetes  |
                                                  |   Cluster   |
                                                  +-------------+
                                                         |
                                                         v
                                                  +-------------+
                                                  | Rolling     |
                                                  | Deployment  |
                                                  +-------------+

                                                          |
                                                          v

                                               +------------------+
                                               | Slack Alerts     |
                                               +------------------+
```

---

# ☁️ Infrastructure Provisioned with Terraform

The complete AWS infrastructure is provisioned using Terraform following Infrastructure-as-Code (IaC) principles.

## Resources Created

```text
Terraform
│
├── VPC
├── Public Subnets
├── Private Subnets
├── Internet Gateway
├── NAT Gateway
├── Route Tables
├── Security Groups
├── IAM Roles & Policies
├── Amazon ECR Repository
├── Amazon EKS Cluster
└── EKS Managed Node Groups
```

### Benefits

- Repeatable Infrastructure Deployment
- Version Controlled Infrastructure
- Reduced Manual Configuration
- Faster Environment Provisioning
- Scalable Cloud Architecture

---

# ⚙️ CI/CD Pipeline Workflow

## 1. Source Control

- Developers push code to GitHub.
- GitHub Webhooks automatically trigger the Jenkins pipeline.

## 2. Build & Unit Testing

- Source code checkout from GitHub.
- Maven build execution.
- Automated unit testing.

## 3. Static Code Analysis

- Checkstyle validates coding standards.
- SonarQube performs code quality analysis.
- Code smells, bugs, vulnerabilities, and coverage metrics are evaluated.

## 4. Quality Gate Validation

- Jenkins waits for SonarQube Quality Gate results.
- Build execution stops if quality thresholds are not met.

## 5. Artifact Management

- WAR artifacts are generated.
- Artifacts are uploaded to Nexus Repository Manager.
- Artifact versions are preserved for traceability.

## 6. Containerization

- Multi-stage Docker images are built.
- Application runtime is separated from build dependencies.
- Image size and attack surface are minimized.

## 7. Security Scanning

- Trivy scans Docker images.
- HIGH and CRITICAL vulnerabilities are detected.
- Vulnerable images are blocked from deployment.

## 8. Container Registry

- Docker images are tagged using Jenkins Build Numbers.
- Images are published to Amazon ECR.

Example:

```bash
vprofile:latest
vprofile:${BUILD_NUMBER}
```

## 9. Kubernetes Deployment

The latest container image is deployed to Amazon EKS.

Example:

```bash
kubectl set image deployment/vprofile \
vprofile=<ECR_IMAGE_URI>:${BUILD_NUMBER}
```

Deployment activities include:

- Image update
- Replica replacement
- Rolling updates
- Deployment verification

## 10. Rollout Verification

Deployment health is validated before pipeline completion.

```bash
kubectl rollout status deployment/vprofile
```

## 11. Notifications

Slack notifications provide:

- Build Status
- Deployment Status
- Failed Stage Alerts
- Pipeline Completion Notifications

---

# 🛠️ Technology Stack

## CI/CD

- Jenkins
- GitHub Webhooks

## Build & Testing

- Maven
- JUnit

## Code Quality

- SonarQube
- Sonar Quality Gates
- Checkstyle

## Artifact Management

- Nexus Repository Manager

## Containerization

- Docker
- Multi-Stage Docker Builds

## Security

- Trivy

## Cloud Platform

- AWS EC2
- Amazon ECR
- Amazon EKS
- IAM

## Infrastructure as Code

- Terraform

## Container Orchestration

- Kubernetes

## Notifications

- Slack

---

# 📋 Jenkins Pipeline Stages

```
Git Checkout
      │
      ▼
Maven Build
      │
      ▼
Unit Testing
      │
      ▼
Checkstyle Analysis
      │
      ▼
SonarQube Analysis
      │
      ▼
Quality Gate Validation
      │
      ▼
Artifact Upload to Nexus
      │
      ▼
Docker Image Build
      │
      ▼
Trivy Security Scan
      │
      ▼
Push Image to Amazon ECR
      │
      ▼
Deploy to Amazon EKS
      │
      ▼
Rollout Verification
      │
      ▼
Slack Notification
```

---

# 💡 Key Implementation Highlights

## Infrastructure Automation

- Automated AWS infrastructure provisioning using Terraform.
- Provisioned networking, security, IAM, and Amazon EKS resources.
- Implemented Infrastructure-as-Code best practices.

## DevSecOps Implementation

- Integrated SonarQube Quality Gates.
- Implemented Checkstyle validation.
- Enforced Trivy vulnerability scanning.
- Prevented vulnerable images from reaching deployment environments.

## Kubernetes Automation

- Automated deployments to Amazon EKS.
- Implemented rolling updates for zero downtime.
- Verified deployment health using rollout status checks.
- Automated image versioning using Jenkins Build Numbers.

## Container Optimization

- Built optimized multi-stage Docker images.
- Reduced container image size.
- Improved deployment efficiency and security posture.

## Monitoring & Notifications

- Integrated Slack notifications.
- Real-time build and deployment visibility.
- Faster incident response and troubleshooting.

---

# 🔧 Troubleshooting & Operational Experience

## Jenkins

- Maven dependency resolution failures
- SonarQube authentication issues
- Nexus artifact upload failures
- Docker build failures
- AWS integration issues
- Credential management issues

## Kubernetes

- ImagePullBackOff
- CrashLoopBackOff
- Pod Scheduling Failures
- Service Discovery Issues
- Deployment Rollout Failures
- EKS Authentication Issues


## AWS

- ECR Authentication Problems
- IAM Permission Errors
- EKS Access Management
- Terraform Backend Configuration Issues
- Terraform State Management Problems

---

# 📚 Key Learning Outcomes

- Infrastructure as Code (Terraform)
- Jenkins Pipeline Development
- DevSecOps Best Practices
- Kubernetes Administration
- Amazon EKS Operations
- Container Security
- Docker Image Optimization
- CI/CD Automation
- AWS Cloud Infrastructure
- Production-Style Deployment Workflows

---




