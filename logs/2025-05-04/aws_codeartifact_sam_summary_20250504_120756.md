
# Recap: Using Private AWS CodeArtifact Packages with AWS SAM and pip

## Key Concepts and Learnings

### 1. Authenticating with AWS CodeArtifact

- Use AWS CLI to fetch an authorization token:
  ```bash
  aws codeartifact get-authorization-token --domain <your-domain> --domain-owner <your-account-id>
  ```
- Export the token as an environment variable for pip:
  ```bash
  export CODEARTIFACT_AUTH_TOKEN=<your-token>
  ```

### 2. Configuring pip to Use CodeArtifact

- Update or create a `pip.conf` (Linux/macOS) or `pip.ini` (Windows) file:
  ```ini
  [global]
  extra-index-url = https://aws:${CODEARTIFACT_AUTH_TOKEN}@<your-domain-id>.d.codeartifact.<region>.amazonaws.com/pypi/<repo-name>/simple/
  ```

- Alternatively, specify it in the `requirements.txt` using:
  ```
  --extra-index-url https://aws:${CODEARTIFACT_AUTH_TOKEN}@<your-domain-id>.d.codeartifact.<region>.amazonaws.com/pypi/<repo-name>/simple/
  ```

### 3. Sharing Code with Private Dependencies

- To share code reproducibly:
  - Include a script or `.env` file that automates the process of setting `CODEARTIFACT_AUTH_TOKEN`.
  - Document how to retrieve the token using AWS CLI.
  - Consider using `pip-tools` or `requirements.lock` to pin versions explicitly.

### 4. Security Considerations

- Do **not** hardcode tokens in source files.
- Use Secrets Manager or environment variables in CI/CD.
- Consider role-based access or scoped tokens for different users.

### 5. Automation in CI/CD

- In CI/CD pipelines (e.g., GitHub Actions or CodeBuild):
  - Retrieve token as a separate step.
  - Inject it as an environment variable into the build environment.
  - Ensure the token has a valid TTL and is rotated periodically.

---

This summary includes actionable best practices for authenticating with AWS CodeArtifact and using private packages in a Python-based SAM project with pip.
