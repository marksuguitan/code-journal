
# Recommendation: Use Aurora PostgreSQL + OpenSearch for Medical Abstract Indexing

## ✅ Summary Recommendation

**Start with Aurora PostgreSQL as your main data store, and pair it with OpenSearch for full-text and semantic search. Do NOT use DynamoDB initially.**

---

## 📌 Why This Approach Is Recommended

### 1. Simpler Architecture

- Aurora alone handles **both ingestion and querying** — no need to maintain a second database.
- You avoid **duplicated data**, **sync logic**, and **replication errors** between DynamoDB and Aurora.
- One data model to maintain and evolve.

### 2. PostgreSQL Already Meets Your Needs

- Aurora PostgreSQL supports:
  - SQL queries, joins, foreign keys
  - Full-text search with `tsvector` + GIN indexes
  - Vector search with the `pgvector` extension
- It easily handles **millions of records** with proper indexing.

### 3. Integrates Cleanly with OpenSearch

- Aurora can feed data into OpenSearch for:
  - Full-text keyword search
  - Semantic/vector search with reranking
- AWS supports **zero-ETL integration** or streaming tools like DMS for syncing data to OpenSearch.

### 4. Lower Operational Complexity

- No need to maintain:
  - DynamoDB Streams
  - Lambda-based replication pipelines
  - Dual-database schemas and APIs
- Easier backups, DR, and schema evolution.

### 5. Future-Proof: Add DynamoDB If Needed Later

- If ingestion ever becomes a bottleneck, **you can introduce DynamoDB** then as a high-throughput write buffer.
- This defers complexity until justified by scale.

### 6. Cost-Efficient and Developer-Friendly

- One database means:
  - Lower cost (only Aurora + OpenSearch storage and compute)
  - Faster onboarding and less dev friction
  - Easier query logic (one SQL system vs. mixing NoSQL and SQL)

---

## ✅ When to Reconsider

Only consider adding DynamoDB if:
- You hit **write throughput bottlenecks** that Aurora can’t handle.
- You begin ingesting **millions of abstracts per day**, not just total.

---

## 🔚 Final Call

> Use **Aurora PostgreSQL as your source of truth**, model relationships relationally, and push data to **OpenSearch** for search.  
> Avoid the dual-database approach unless proven necessary with scale.

---

**Optional next step:** Want a suggested schema for the Aurora setup?
