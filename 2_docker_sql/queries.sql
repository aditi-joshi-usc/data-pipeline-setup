select 
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	total_amount,
	CONCAT(zpu."Borough", ' / ', zpu."Zone") as "pickup_loc",
	CONCAT(zdo."Borough", ' / ', zdo."Zone") as "dropoff_loc"
	
	
from 
	yellow_taxi_trip t,
	zones zpu,
	zones zdo
where
	t."PULocationID" = zpu."LocationID" 
and
	t."DOLocationID" = zdo."LocationID"
	
 
limit 100;



--------------------------------
select 
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	total_amount,
	CONCAT(zpu."Borough", ' / ', zpu."Zone") as "pickup_loc",
	CONCAT(zdo."Borough", ' / ', zdo."Zone") as "dropoff_loc"
	
	
from 
	yellow_taxi_trip t JOIN zones zpu ON t."PULocationID" = zpu."LocationID"
	JOIN zones zdo ON t."DOLocationID" = zdo."LocationID"
	
 
limit 100;

--------------------------------
select 
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	total_amount,
	CONCAT(zpu."Borough", ' / ', zpu."Zone") as "pickup_loc",
	CONCAT(zdo."Borough", ' / ', zdo."Zone") as "dropoff_loc"
	
	
from 
	yellow_taxi_trip t LEFT JOIN zones zpu ON t."PULocationID" = zpu."LocationID"
	JOIN zones zdo ON t."DOLocationID" = zdo."LocationID"
	
 
limit 100;

--------------------------------
select 
	cast(tpep_dropoff_datetime AS DATE) as "day",
	count(1)	
from 
	yellow_taxi_trip t LEFT JOIN zones zpu ON t."PULocationID" = zpu."LocationID"
	JOIN zones zdo ON t."DOLocationID" = zdo."LocationID"
group by cast(tpep_dropoff_datetime AS DATE)
 order by "day" ASC
limit 100;
