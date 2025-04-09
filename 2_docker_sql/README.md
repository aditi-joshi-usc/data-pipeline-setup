# ETL Pipeline with Docker, Postgres, and SQLAlchemy

This project demonstrates a simple ETL setup using Docker containers, PostgreSQL, and Python. It includes a basic pipeline that accepts a command-line argument and connects to a Postgres database.

---

## Project Status

This is a work-in-progress project for practicing containerized data workflows and SQL interaction.

---

## Setup Instructions

### Build the Docker Image

```
docker build -t test:pandas .
▶️ Run the Docker Container
bash
Copy
Edit
docker run -it test:pandas '2024-01-01'
```
This will run pipeline.py and pass the date (sys.argv[1]) to the script.

# PostgreSQL Setup
🚀 Start the Postgres Container
```
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v "${PWD}/ny_taxi_postgres_data:/var/lib/postgresql/data" \
  -p 5432:5432 \
  postgres:13
```

# Connect with pgcli (Optional CLI)
## Install pgcli
``` 
pip install pgcli
```
#Connect to the Database
```
pgcli -h localhost -p 5432 -U root -d ny_taxi

```
## Useful Commands:
```
\dt                 -- List tables
\c ny_taxi          -- Connect to DB
\d yellow_taxi_data -- Describe the table
```
# SQLAlchemy Connection
## Install SQLAlchemy
```
pip install sqlalchemy
```
## Connect to Postgres
```
from sqlalchemy import create_engine

engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')
engine.connect()
```