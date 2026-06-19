DevSecOps IaC Scanner: Checkov

Welcome to the **Infrastructure as Code (IaC) Security Automation** portfolio piece. This project demonstrates how to implement a local and pipeline-driven security scanner using **Checkov** to enforce cloud infrastructure hardening prior to deployment.

This architecture ensures that all Terraform definitions adhere to enterprise security baselines, dynamically catching misconfigurations such as unencrypted databases or publicly exposed S3 buckets.

---

##  Table of Contents
- [Architecture Overview](#-architecture-overview)
- [1. The Security Scanner (Checkov)](#1-the-security-scanner-checkov)
- [2. The Local DevSecOps Workflow](#2-the-local-devsecops-workflow)
- [3. The CI/CD Pipeline Guardrails](#3-the-cicd-pipeline-guardrails)
- [4. Hardening Infrastructure as Code (Terraform)](#4-hardening-infrastructure-as-code-terraform)

---

## Architecture Overview

In an enterprise environment, deploying "functional" infrastructure is not enough; it must be "secure" infrastructure. This project utilizes:
1. **Checkov:** An open-source SAST tool by Palo Alto Networks, built specifically to scan IaC configurations (Terraform, CloudFormation, Kubernetes).
2. **Local Auditing:** Running Checkov directly in the developer terminal to shift security completely left.
3. **Pipeline Automation:** Integrating Checkov into GitHub Actions to enforce a strict security tollbooth upon code merges.

---

##  1. The Security Scanner (Checkov)

Checkov acts as the automated security engineer. It compares raw Terraform code against hundreds of predefined enterprise security baselines and compliance frameworks (like CIS, SOC2, and HIPAA). 

If a developer attempts to deploy an S3 bucket without KMS encryption or versioning, Checkov flags the vulnerability and blocks the execution, providing a direct link to the documentation required to fix the error.

---

##  2. The Local DevSecOps Workflow

Before code ever reaches the internet, DevSecOps engineers audit infrastructure locally.

**Installation:**
```bash
python3 -m venv checkov-env
source checkov-env/bin/activate
pip install checkov
```

**Execution:**
Running `checkov -d .` inside the repository forces the scanner to evaluate all local Terraform files, generating a pass/fail compliance report directly in the terminal.

---

##  3. The CI/CD Pipeline Guardrails

To prevent developers from bypassing local checks, Checkov is integrated into a GitHub Actions pipeline. If vulnerable infrastructure code is pushed, the Checkov action triggers an `exit 1` failure, and GitHub's Branch Protection Rules block the merge to production.

```yaml
# File: .github/workflows/security-pipeline.yml
name: DevSecOps IaC Scanner (Checkov)

on: 
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  scan-infrastructure:
    runs-on: ubuntu-latest
    steps:
      - name: Download Repository Code
        uses: actions/checkout@v4

      - name: Execute Checkov Security Scan
        uses: bridgecrewio/checkov-action@master
        with:
          directory: . 
          framework: terraform 
```

---

##  4. Hardening Infrastructure as Code (Terraform)

This project demonstrates the process of taking a vulnerable, "naked" S3 bucket and hardening it into an enterprise-grade resource by attaching mandatory security controls.

**The Hardened Configuration:**
* **Versioning Enabled:** Protects against accidental deletion or ransomware.
* **Access Logging:** Ensures all requests to the bucket are audited.
* **KMS Encryption:** Enforces strict server-side encryption at rest.
* **Lifecycle Rules:** Automatically archives old data to cost-effective storage.
* **Public Access Blocks:** Strictly denies public ACLs and policies.
