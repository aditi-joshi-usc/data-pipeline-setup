import argparse
import pandas as pd
from sqlalchemy import create_engine
from time import time
import os

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url

    csv_gz_name = 'output.csv.gz'

    # Use curl to download the gzip file
    os.system(f'curl -L -o {csv_gz_name} {url}')

    # Create DB connection
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    # Read in chunks from the gzip file
    df_iter = pd.read_csv(csv_gz_name, iterator=True, chunksize=100000, compression='gzip')

    while True:
        try:
            start_time = time()
            df = next(df_iter)

            if 'tpep_pickup_datetime' in df.columns:
                df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
            if 'tpep_dropoff_datetime' in df.columns:
                df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

            df.to_sql(name=table_name, con=engine, if_exists='append')

            end_time = time()
            print(f"Chunk inserted..., took {end_time - start_time:.3f} seconds")
        except StopIteration:
            print("All chunks processed.")
            break

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV data into Postgres')


        # user, password, host, port, dbname, table_name, url of the csv file 
    parser.add_argument('--user', help='user name for postgres')
    parser.add_argument('--password', help='password for postgres')
    parser.add_argument('--host', help='host for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='database name for postgres')
    parser.add_argument('--table_name', help='name of the table where we will write the results to')
    parser.add_argument('--url', help='url of the csv file')




    args = parser.parse_args()

    main(args)








