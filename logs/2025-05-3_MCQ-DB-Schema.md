# MCQ Database Architecture and Schema

## 1. Choose the Right Database for the Job
- Use **Postgres** if you need relationships, transactions, or flexible querying.
- Use **DynamoDB** if you need massive scale, low latency, and know your access patterns ahead of time.
- Start with **Postgres (Aurora Serverless v2)** for your MCQ learning app due to its relational complexity and cost efficiency at low/moderate scale.

## 2. Use Aurora Serverless v2 Wisely
- Benefit from auto-scaling, ACID support, and lower cost when usage is scattered and bursty.
- Store your DB in a private subnet and access it via your backend.
- For public access, route all client requests through a secured backend API (e.g. via Lambda + API Gateway).
- Scale to global availability later using **Aurora Global Databases** for disaster recovery and performance.

## 3. Select an ORM Strategy
- Use **Prisma (JavaScript)** for migrations and schema source of truth—clean DX, type safety, great dev tools.
- Use **SQLAlchemy (Python)** for querying and model reflection. Sync version is fine with Lambda.
- Avoid managing migrations from both ends—let Prisma own schema changes, and sync Python via reflection or `sqlacodegen`.

## 4. Model Document Upload & Storage Intelligently
- Store plain text directly in Postgres if content is small (<1 MB).
- Offload larger content (>=1 MB) to S3 and store a reference URL in the DB.
- For exports, dynamically generate files like `.txt` or `.pdf` on demand using backend logic.
- For imports:
  - Use `python-docx` for `.docx`
  - Use Google Docs API for `.gdoc`
  - Normalize everything to plain text or HTML for WYSIWYG insertion

## 5. Build a Flexible MCQ Schema
- Model core educational content with:
  - `scenarios` table → context or setup text
  - `questions` table → prompt, MCQ flag, explanation
  - `choices` table → for MCQ only
  - `answers` table → store user input
- Add `is_multiple_choice` flag to allow mixed formats
- Keep the stem/context (`scenario`) in a separate table to allow multiple linked questions

## 6. Enable Question Flows and Branching
- Track linear or branching flows by:
  - Adding `first_question_id` to `scenarios`
  - Creating a `question_links` table with:
    - `from_question_id`
    - `to_question_id`
    - `condition` (e.g. `answer == A` or `default`)
- Create a `user_progress` table to track where a user is within a scenario.
- Support follow-up questions by chaining questions with logic-driven paths.
