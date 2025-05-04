# Recap: Managing Python Dependencies and Private Indexes

This document summarizes best practices and tools for managing Python dependencies, including handling private repositories like AWS CodeArtifact.

---

## 📦 `pip freeze` Behavior

- `pip freeze` lists all packages installed in the environment, including transitive dependencies.
- It captures everything needed to reproduce the environment but may include more than what you explicitly installed.

---

## ✅ Best Practices for Dependency Management

### 1. Use `requirements.in` + `pip-tools`

- Define top-level packages only in `requirements.in`.
- Run `pip-compile` to generate a fully pinned `requirements.txt`.

Example:

```bash
pip install pip-tools
pip-compile requirements.in
```

- This generates a deterministic, reproducible environment.

---

## 🔁 Updating Packages

```bash
pip-compile --upgrade
```

- Keeps direct and transitive dependencies up-to-date while preserving compatibility.

---

## 📁 Version Control

- Track both `requirements.in` and `requirements.txt` in Git.
- `requirements.in` shows intent (what you requested), while `requirements.txt` ensures reproducibility.

---

## 🔒 Lock Files

- Treat `requirements.txt` as a lock file.
- Similar to `package-lock.json` (npm) or `poetry.lock`.

---

## 🔐 Using Private Repositories (e.g., CodeArtifact)

### Configure pip to use multiple indexes:

```bash
pip install --index-url https://my-codeartifact-url             --extra-index-url https://pypi.org/simple my-private-package
```

### Authentication

- Use environment variables or `pip.conf` to pass auth tokens.
- NEVER hardcode credentials in source files.

---

## ⚙️ Optional Tools

- **Poetry**: Manages dependencies, environments, and builds with `pyproject.toml`.
- **pipenv**: Deprecated for many use cases in favor of Poetry or pip-tools.

---

## 📌 Summary

| Tool         | Purpose                        |
|--------------|--------------------------------|
| `pip freeze` | Snapshot all installed packages |
| `pip-tools`  | Compile and manage pinned deps |
| `Poetry`     | All-in-one dependency manager   |
| `pip.conf`   | Persist pip index settings     |
| AWS CLI      | Fetch CodeArtifact auth tokens |

