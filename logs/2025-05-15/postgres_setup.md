You have two easy ways to spin up a PostgreSQL server on your machine: using Docker (quick and isolated), or installing it natively (via your OS package manager or installer). Choose whichever fits your workflow.

---

## 1. Quick & Disposable: Run Postgres in Docker

If you have Docker installed, a single command will get you a fresh Postgres server:

```bash
docker run -d \
  --name pg-local \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=mydb \
  -p 5432:5432 \
  postgres:latest
```

- `--name pg-local` gives your container a friendly name.  
- `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` initialize a default user, password, and database.  
- `-p 5432:5432` maps container port 5432 to your host.  
- `postgres:latest` grabs the official image from Docker Hub.

Once it’s up, you can connect with any client:

```bash
psql -h localhost -U postgres -d mydb
# password: postgres
```

When you’re done, tear it down with:

```bash
docker stop pg-local
docker rm pg-local
```

---

## 2. Native Installation

### macOS (Homebrew)

```bash
brew update
brew install postgresql

# Initialize the database cluster (only first time):
initdb /usr/local/var/postgres

# Start the server:
brew services start postgresql

# To stop:
brew services stop postgresql
```

By default this creates a UNIX socket server and listens on port 5432. You can connect via:

```bash
psql postgres
```

### Ubuntu / Debian

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib

# The service is started automatically. To check:
sudo systemctl status postgresql

# To start/stop/restart:
sudo systemctl start postgresql
sudo systemctl stop postgresql
sudo systemctl restart postgresql

# Switch to the `postgres` system user and open psql:
sudo -i -u postgres
psql
```

From inside `psql`, create a database or user if you like:

```sql
CREATE DATABASE mydb;
CREATE USER myuser WITH ENCRYPTED PASSWORD 'mypassword';
GRANT ALL PRIVILEGES ON DATABASE mydb TO myuser;
```

### Windows

1. Download the Windows installer from https://www.enterprisedb.com/downloads/postgres-postgresql-installer.
2. Run it and follow the wizard—you’ll choose an install directory, default port (5432), a “postgres” superuser password, and optionally StackBuilder tools.
3. After install, the PostgreSQL server runs as a Windows service named “postgresql-x64-<version>”. You can start/stop it via Services or the Start menu shortcut.
4. Open “SQL Shell (psql)” from the Start menu, enter your password, and you’re connected.

---

## 3. Verify & Connect

No matter which route you choose, verify your server is up:

```bash
# From your shell:
psql -h localhost -p 5432 -U postgres -l
```

This lists all databases. Or simply:

```bash
psql postgres
# then at the psql prompt:
\dt       -- list tables
\q        -- quit
```

---

## 4. Next Steps

- **Create more databases/users**: use `CREATE DATABASE` / `CREATE USER` in psql.  
- **Configure access**: edit `postgresql.conf` (listen_addresses) and `pg_hba.conf` (authentication rules) if you need remote access.  
- **Backups**: use `pg_dump` and `pg_restore` to export/import schemas and data.  
- **Integrate Flyway**: point your `flyway.conf` at `jdbc:postgresql://localhost:5432/mydb` with the correct user/password, then `flyway migrate` to apply your migrations.

With PostgreSQL running locally, you’re now ready to develop, test migrations, and iterate safely!
