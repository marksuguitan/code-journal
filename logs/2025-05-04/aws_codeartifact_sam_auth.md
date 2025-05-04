# Recap: Using AWS CodeArtifact with AWS SAM

This document summarizes how to ensure proper authentication and authorization when installing private Python packages from AWS CodeArtifact during the **SAM build step** in your AWS Lambda project.

---

## 🧠 Key Learnings

### 1. **The Problem**
You need to install a private Python package from AWS CodeArtifact during the build step of your AWS SAM project.

### 2. **Why This Is an Issue**
By default, `sam build` does not have your AWS CodeArtifact credentials. As a result, pip install inside the build container will fail when trying to fetch private packages.

---

## ✅ Solution: Authenticate pip with CodeArtifact during Build

### Method: Use `pip config` or `pip install` with a `--extra-index-url` and token

You can pass authentication tokens via `PIP_EXTRA_INDEX_URL`, `PIP_INDEX_URL`, or `pip.conf`.

---

## 🛠️ Step-by-Step Setup

### 1. **Generate the CodeArtifact Token**

You can generate a token using the AWS CLI:

```bash
aws codeartifact get-authorization-token \
  --domain <domain> \
  --domain-owner <account-id> \
  --query authorizationToken \
  --output text
```

Or inline in bash:

```bash
export CODEARTIFACT_AUTH_TOKEN=$(aws codeartifact get-authorization-token \
  --domain your-domain \
  --domain-owner your-account-id \
  --query authorizationToken \
  --output text)
```

---

### 2. **Pass the Token to pip in `sam build`**

Use environment variables with `sam build`:

```bash
sam build --use-container \
  --container-env-vars PIP_EXTRA_INDEX_URL="https://aws:$CODEARTIFACT_AUTH_TOKEN@<your-domain>-<account-id>.d.codeartifact.<region>.amazonaws.com/pypi/<repo>/simple/"
```

Or create a `pip.conf` with your credentials.

---

### 3. **Security Tip**

Never hardcode the token. Use environment variables or AWS Secrets Manager in production.

---

### 4. **Best Practices**

- Use a private repository like AWS CodeArtifact to store internal packages.
- Use `requirements.txt` or `requirements.in` compiled by `pip-tools`.
- Pin versions in `requirements.txt` for reproducibility.
- Use `.npmrc`, `.pypirc`, or `.pip.conf` to manage private indexes locally or in CI/CD.
