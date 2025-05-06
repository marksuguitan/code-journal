A database of medical abstracts, studies and evidence.

# Stack

## Databases

- Aurora as PostgreSQL
- AWS OpenSearch

### Database Schema
'''sql
-- 1. Core table for publications
CREATE TABLE publications (
  id                SERIAL PRIMARY KEY,
  title             TEXT        NOT NULL,
  abstract_text     TEXT,                     -- the truncated abstract/summary
  publication_date  DATE,
  journal_id        INT         REFERENCES journals(id),
  ingestion_date    TIMESTAMPTZ NOT NULL DEFAULT now(),
  source_db         VARCHAR(50),
  status            VARCHAR(20)               -- e.g. 'pending', 'validated', 'rejected'
);

-- 2. Journals (or conference proceedings, etc.)
CREATE TABLE journals (
  id    SERIAL PRIMARY KEY,
  name  TEXT     NOT NULL,
  issn  VARCHAR(20)
);

-- 3. Authors
CREATE TABLE authors (
  id           SERIAL PRIMARY KEY,
  first_name   TEXT,
  last_name    TEXT,
  affiliation  TEXT,
  orcid        VARCHAR(19)  -- optional ORCID iD
);

-- link table for publications ⇄ authors (with ordering)
CREATE TABLE publication_authors (
  publication_id INT NOT NULL REFERENCES publications(id),
  author_id      INT NOT NULL REFERENCES authors(id),
  author_order   INT NOT NULL,
  PRIMARY KEY (publication_id, author_id)
);

-- 4. Identifier types (DOI, PMID, arXiv, etc.)
CREATE TABLE identifier_types (
  id    SERIAL PRIMARY KEY,
  name  VARCHAR(50) UNIQUE NOT NULL
);

-- link table for publications ⇄ identifiers
CREATE TABLE publication_identifiers (
  publication_id     INT NOT NULL REFERENCES publications(id),
  identifier_type_id INT NOT NULL REFERENCES identifier_types(id),
  identifier_value   VARCHAR(100) NOT NULL,
  PRIMARY KEY (publication_id, identifier_type_id)
);

-- 5. Keywords (for simple tagging/indexing)
CREATE TABLE keywords (
  id      SERIAL PRIMARY KEY,
  keyword TEXT UNIQUE NOT NULL
);

CREATE TABLE publication_keywords (
  publication_id INT NOT NULL REFERENCES publications(id),
  keyword_id     INT NOT NULL REFERENCES keywords(id),
  PRIMARY KEY (publication_id, keyword_id)
);

-- 6. Track validation issues (e.g. missing required identifier)
CREATE TABLE publication_flags (
  id             SERIAL PRIMARY KEY,
  publication_id INT NOT NULL REFERENCES publications(id),
  flag_type      VARCHAR(50) NOT NULL,  -- e.g. 'missing_doi', 'unrecognized_id'
  details        TEXT,
  flagged_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);
'''