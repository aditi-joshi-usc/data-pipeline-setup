
# ETL Pipeline with Docker, Postgres, and SQLAlchemy

This project demonstrates a simple ETL setup using Docker containers, PostgreSQL, and Python. It includes a pipeline that accepts command-line arguments and connects to a Postgres database. The setup also includes optional tools like `pgcli` and `pgAdmin` for database interaction and monitoring.

---

## Project Status

This is a **work-in-progress** project to practice containerized data workflows, ingestion pipelines, and SQL interaction using Docker.

---

## Setup Instructions

### Build the Docker Image

```bash
docker build -t test:pandas .
```

### Run the Docker Container

```bash
docker run -it test:pandas '2024-01-01'
```

This runs `pipeline.py` and passes the date as `sys.argv[1]`.

---

## PostgreSQL Setup

### Start the Postgres Container

```bash
docker run -it   -e POSTGRES_USER="root"   -e POSTGRES_PASSWORD="root"   -e POSTGRES_DB="ny_taxi"   -v "${PWD}/ny_taxi_postgres_data:/var/lib/postgresql/data"   -p 5432:5432   postgres:13
```

---

## Connect to PostgreSQL with `pgcli` (Optional)

### Install `pgcli`

```bash
pip install pgcli
```

### Connect to the Database

```bash
pgcli -h localhost -p 5432 -U root -d ny_taxi
```

### Useful SQL Commands

```sql
\dt                 -- List tables
\c ny_taxi          -- Connect to DB
\d yellow_taxi_data -- Describe table
```

---

## SQLAlchemy Integration

### Install SQLAlchemy

```bash
pip install sqlalchemy
```

### Connect Using Python

```python
from sqlalchemy import create_engine

engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')
engine.connect()
```

---

## pgAdmin Setup (Optional UI Tool)

### Create Docker Network

```bash
docker network create pg-network
```

### Run Postgres Container on the Network

```bash
docker run -it   --name pg-database   --network pg-network   -e POSTGRES_USER="root"   -e POSTGRES_PASSWORD="root"   -e POSTGRES_DB="ny_taxi"   -v "${PWD}/ny_taxi_postgres_data:/var/lib/postgresql/data"   -p 5432:5432   postgres:13
```

### Run pgAdmin Container

```bash
docker run -it   --name pgadmin   --network pg-network   -e PGADMIN_DEFAULT_EMAIL="admin@admin.com"   -e PGADMIN_DEFAULT_PASSWORD="root"   -p 8080:80   dpage/pgadmin4
```

Access pgAdmin at [http://localhost:8080](http://localhost:8080)

---

## Ingesting Data with Docker (ETL)

### Convert Jupyter Notebook to Script (Optional)

```bash
jupyter nbconvert --to script upload_data.ipynb
```

### Build the Ingestion Image

```bash
docker build -t taxi_ingest:v001 .
```

### Run the Ingestion Pipeline (with arguments)

```bash
docker run -it taxi_ingest:v001   --user=root --password=root --host=localhost --port=5432   --db=ny_taxi --table_name=yellow_taxi_trip   --url=https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz
```

### Run via Docker Network (Recommended with pgAdmin)

```bash
docker run -it --network=pg-network taxi_ingest:v001   --user=root --password=root --host=pg-database --port=5432   --db=ny_taxi --table_name=yellow_taxi_trip   --url=https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz
```

---

## Local Hosting Alternative (Faster File Access)

### Start Python HTTP Server

```bash
python -m http.server 8000
```

### Get Your Local IP

```bash
ipconfig
```

Use the IPv4 address (e.g., `172.20.224.1`) and define:

```
URL=http://172.20.224.1:8000/yellow_tripdata_2021-01.csv
```

### Use with Docker:

```bash
docker run -it --network=pg-network taxi_ingest:v001   --user=root --password=root --host=pg-database --port=5432   --db=ny_taxi --table_name=yellow_taxi_trip   --url=${URL}
```

---

