# 🛠️ Infrastructure Setup Guide

This project uses a multi-server architecture to simulate a real-world enterprise DevSecOps environment. Separating services across dedicated servers improves scalability, reduces resource contention, and aligns with industry best practices.

---

# 📐 Infrastructure Overview

The platform consists of three Linux servers:

| Server | Purpose |
|----------|----------|
| Server 1 | Jenkins Build Server |
| Server 2 | SonarQube Server |
| Server 3 | Nexus Repository Server |

---

## Architecture

```text
                    +----------------+
                    |    GitHub      |
                    +--------+-------+
                             |
                             |
                             v

                   +------------------+
                   | Jenkins Server   |
                   | (Build Machine)  |
                   +--------+---------+
                            |
        ------------------------------------------
        |                                        |
        v                                        v

 +---------------+                     +----------------+
 | SonarQube     |                     | Nexus Repo     |
 | Quality Gate  |                     | Artifact Store |
 +---------------+                     +----------------+

                            |
                            v

                     Amazon ECR
                            |
                            v

                     Amazon EKS
```

---

# 🖥️ Server Configuration

## Server 1 - Jenkins Build Server

### Purpose

This server hosts Jenkins and executes the complete CI/CD pipeline.

### Software Installed

```text
Java (JDK 17)
Maven 3.9.x
Docker Engine
Trivy
AWS CLI
kubectl
Terraform
Git
jq
Jenkins
```

### Responsibilities

- Source Code Checkout
- Build Automation
- Unit Testing
- SonarQube Analysis
- Nexus Artifact Upload
- Docker Build
- Trivy Security Scan
- Amazon ECR Push
- Amazon EKS Deployment
- Slack Notifications

---

## Server 2 - SonarQube Server

### Purpose

Hosts SonarQube for static code analysis and quality gate validation.

### Deployment

The SonarQube server is provisioned automatically using:

```bash
userdata/sonar-setup.sh
```

### Default Access

```text
URL: http://<sonarqube-server-public-ip>:9000
```

### Responsibilities

- Code Quality Analysis
- Quality Gates
- Code Coverage Reporting
- Vulnerability Detection
- Technical Debt Analysis

---

## Server 3 - Nexus Repository Server

### Purpose

Hosts Nexus Repository Manager for artifact storage and dependency management.

### Deployment

The Nexus server is provisioned automatically using:

```bash
userdata/nexus-setup.sh
```

### Default Access

```text
URL: http://<nexus-server-public-ip>:8081
```

### Responsibilities

- Artifact Storage
- WAR Package Repository
- Build Version Management
- Dependency Management

---

# 🔐 Security Group Configuration

## Jenkins Server

Allow:

```text
22     SSH
8080   Jenkins UI
```

---

## SonarQube Server

Allow:

```text
22     SSH
9000   SonarQube UI
```

---

## Nexus Server

Allow:

```text
22     SSH
8081   Nexus UI
```

---

# ⚙️ Jenkins Server Configuration

After Jenkins installation, configure the required tools, plugins, and credentials.

---

## Required Plugins

Navigate to:

```text
Manage Jenkins
 └── Plugins
      └── Available Plugins
```

Install the following plugins:

### Source Control

- Git
- GitHub Integration

### Build & Testing

- Maven Integration
- Pipeline Maven Integration

### Code Quality

- SonarQube Scanner

### Artifact Management

- Nexus Artifact Uploader

### Containerization

- Docker Pipeline

### Security

- Pipeline Utility Steps

### AWS Integration

- Pipeline AWS Steps
- AWS Credentials

### Kubernetes

- Kubernetes CLI Plugin

### Notifications

- Slack Notification

---

## Global Tool Configuration

Navigate to:

```text
Manage Jenkins
 └── Tools
```

Configure:

### JDK

```text
Name: JDK17
Version: JDK 17
```

### Maven

```text
Name: MAVEN3
Version: Maven 3.9.x
```

### SonarQube Scanner

```text
Name: sonar-scanner
```

---

# 🔑 Jenkins Credentials Configuration

Navigate to:

```text
Manage Jenkins
 └── Credentials
      └── System
           └── Global Credentials
```

Create the following credentials.

---

## GitHub Credentials

```text
Credential ID: gitcreds
Type: Username with Password
```

Used for:

- Git Repository Authentication
- Source Code Checkout

---

## SonarQube Token

```text
Credential ID: sonacreds
Type: Secret Text
```

Used for:

- SonarQube Authentication
- Sonar Analysis

---

## Nexus Credentials

```text
Credential ID: nexuscreds
Type: Username with Password
```

Used for:

- Artifact Upload
- Repository Access

---

## Slack Token

```text
Credential ID: slackcreds
Type: Secret Text
```

Used for:

- Build Notifications
- Deployment Notifications

---

## AWS Credentials

```text
Credential ID: awscreds
Type: AWS Credentials
```

Required Permissions:

```text
AmazonECRFullAccess
AmazonEKSClusterPolicy
AmazonEKSWorkerNodePolicy
IAM Read Access
EC2 Read Access
```

Used for:

- ECR Login
- Image Push
- EKS Deployment
- Cluster Access

---

# ☁️ Jenkins Connectivity Validation

Verify connectivity from Jenkins Server.

### GitHub

```bash
git ls-remote https://github.com/<username>/<repository>.git
```

### SonarQube

```bash
curl http://<SONAR_SERVER_IP>:9000
```

### Nexus

```bash
curl http://<NEXUS_SERVER_IP>:8081
```

### AWS

```bash
aws sts get-caller-identity
```

### EKS

```bash
aws eks update-kubeconfig \
--region us-east-1 \
--name <cluster-name>

kubectl get nodes
```

---

# ✅ Pre-Deployment Checklist

Before running the pipeline, verify:

- Jenkins Server is running
- SonarQube Server is accessible
- Nexus Repository is accessible
- Docker is installed and running
- Trivy is installed
- AWS CLI is configured
- kubectl is installed
- Terraform is installed
- Jenkins credentials are configured
- SonarQube token is added
- Nexus credentials are configured
- Slack token is configured
- AWS credentials are configured
- ECR repository exists
- Amazon EKS cluster is accessible

---

# 🎯 Expected Outcome

After completing the setup:

1. Developer pushes code to GitHub.
2. Jenkins automatically starts the pipeline.
3. Maven builds and tests the application.
4. SonarQube validates code quality.
5. Nexus stores build artifacts.
6. Docker builds the container image.
7. Trivy performs vulnerability scanning.
8. Jenkins pushes the image to Amazon ECR.
9. Amazon EKS is updated with the latest image.
10. Kubernetes performs a rolling deployment.
11. Slack receives build and deployment notifications.