# Journal Entry: Exploring Environment Variables in Python Lambda

*Date: May 8, 2025*

---

Today I dove into the world of environment variables for AWS Lambda and Python, and I wanted to jot down my thoughts and findings in the form of a journal entry. Here’s what I discovered:

---

## Morning Reflections: os.environ vs os.getenv

This morning, I reminded myself how to access environment variables in Python:

- **os.environ**  
  I realized that `os.environ` is like a living dictionary of my process environment. When I do:
  ```python
  import os
  api_key = os.environ['API_KEY']
  ```
  I expect a `KeyError` if `API_KEY` isn’t set. That’s perfect for *critical* settings—I want my function to fail fast if something’s missing.

- **os.getenv**  
  Later, I needed a fallback for a timeout setting. I used:
  ```python
  timeout = int(os.getenv('TIMEOUT_SECONDS', '30'))
  ```
  This quietly returns `'30'` if `TIMEOUT_SECONDS` isn’t present. No exceptions, just a sensible default.

I noted that under the hood, `os.getenv` is simply:
```python
def getenv(key, default=None):
    return os.environ.get(key, default)
```
A tiny helper that spares me from typing `.get`.

---

## Afternoon Experiment: python-dotenv for Local Development

After lunch, I ran into the fact that locally, AWS doesn’t inject my Lambda’s environment variables. To simulate them, I turned to **python-dotenv**:

1. I created a `.env` file in my project root:
   ```
   API_KEY=abcd1234
   ```
2. I added these lines at the top of my `src/app.py`:
   ```python
   from dotenv import load_dotenv
   load_dotenv()  # Loads .env into os.environ
   
   import os
   API_KEY = os.environ['API_KEY']
   ```
3. Running `sam local invoke` or my unit tests, I saw my variables magically appear.

It felt like a time machine: I could run code locally exactly as it would on AWS, without changing a single line when deploying.

---

## Evening Conclusion: Best Practices

As the day wound down, I summarized:

- **Production on Lambda:**  
  - No need for `dotenv`. AWS injects the environment variables I set in the console or via `sam deploy`.
  - I simply use `os.environ['KEY']` or `os.getenv('KEY', default)` in my handler.

- **Local Development:**  
  - Use `python-dotenv` to load a `.env` file into `os.environ`.
  - Keep `.env` out of version control (add it to `.gitignore`).

- **Choosing between os.environ and os.getenv:**  
  - Use `os.environ['KEY']` when the key is essential—let it error loudly if missing.  
  - Use `os.getenv('KEY', default)` when a default is acceptable or the variable is optional.

I’m excited to apply these patterns in my next Lambda project. End of entry.

