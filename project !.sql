CREATE DATABASE car_sales;
USE car_sales;
CREATE TABLE cars (
    brand VARCHAR(50),
    car_name VARCHAR(100),
    price_raw VARCHAR(20),
    safety VARCHAR(20),
    mileage VARCHAR(20),
    power_bhp VARCHAR(20),
    sales_2024 VARCHAR(20)
);
select * from cars;
SET SQL_SAFE_UPDATES = 0;

-- CLEANING DATA 
DELETE FROM cars
WHERE TRIM(brand) = '' OR brand IS NULL
OR TRIM(car_name) = '' OR car_name IS NULL
OR TRIM(price_raw) = '' OR price_raw IS NULL

or trim(safety)= '' or safety is null
OR TRIM(mileage) = '' OR mileage IS NULL
OR TRIM(power_bhp) = '' OR power_bhp IS NULL
OR TRIM(sales_2024) = '' OR sales_2024 IS NULL;
select* from cars;

 -- COUNT OF CARS BY BRAND 
 select 
 brand , COUNT(*) AS total_cars
 from cars
 GROUP BY Brand
 order by total_cars desc;
 
 -- CONVERTING PRICE INTO DECIMALS 


ALTER TABLE cars ADD COLUMN price_in_lakhs DECIMAL(10,2);

UPDATE cars
SET price_in_lakhs = CASE
    WHEN LOWER(price_raw) LIKE '%crore%' THEN
        CAST(
            REPLACE(
                REPLACE(
                    REPLACE(LOWER(price_raw), 'rs.', ''), 'crores', ''
                ), 'crore', ''
            ) AS DECIMAL(10,2)
        ) * 100

    WHEN LOWER(price_raw) LIKE '%lakh%' THEN
        CAST(
            REPLACE(
                REPLACE(
                    REPLACE(LOWER(price_raw), 'rs.', ''), 'lakhs', ''
                ), 'lakh', ''
            ) AS DECIMAL(10,2)

    )
    ELSE NULL
END;
-- AVERAGE PRICE OF CARS AS PER BRAND AND AVERAGE POWER 

select* FROM cars;
	SELECT brand, 
    avg(price_in_lakhs) as avg_price_in_lakhs,
   avg(power_bhp) as avg_bhp 
      from cars
    group by brand 
    order by avg_price_in_lakhs desc;
    
    
    --  SEGMENTS OF CARS 

SELECT 
    brand,
    car_name,
    price_in_lakhs,
    CASE 
        WHEN price_in_lakhs <= 7 THEN 'Budget'
        WHEN price_in_lakhs <= 15 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS price_segment
FROM cars
order by price_in_lakhs desc;

-- rank cars within each brand by price or power

SELECT
    brand,
    car_name,
    price_in_lakhs,
    power_bhp,
    RANK() OVER (PARTITION BY brand ORDER BY price_in_lakhs ASC) AS price_rank,
    RANK() OVER (PARTITION BY brand ORDER BY bhp DESC) AS power_rank
    FROM cars
    group by brand;
    
    SELECT
    brand,
    car_name,
    price_in_lakhs,
    RANK() OVER (PARTITION BY brand ORDER BY price_in_lakhs ASC) AS price_rank
FROM cars
ORDER BY brand asc, price_rank asc;

SELECT *
FROM (
    SELECT
        brand,
        car_name,
        price_in_lakhs,
        RANK() OVER (PARTITION BY brand ORDER BY price_in_lakhs ASC) AS price_rank
    FROM cars
) ranked
WHERE price_rank = 1
ORDER BY brand;

SELECT * FROM cars;

DESCRIBE cars;
UPDATE cars
SET sales_2024 = REPLACE(sales_2024, ',', '');
ALTER TABLE cars
MODIFY sales_2024 INT;

-- 	TOP MOST SELLING CARS  
SELECT car_name, sales_2024
FROM cars
ORDER BY sales_2024 DESC
LIMIT 10;

-- MOST REVENUE GENERATING BRAND 
SELECT
  brand,
  SUM(price_in_lakhs * sales_2024) AS total_revenue_in_lakhs
FROM
  cars
GROUP BY
  brand
ORDER BY
  total_revenue_in_lakhs DESC
LIMIT 10;

-- Brands with most power-full cars 

ALTER TABLE cars ADD COLUMN bhp_numeric FLOAT;
UPDATE cars
SET bhp_numeric = CASE
    WHEN power_bhp LIKE '%-%' THEN (
     
        (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(power_bhp, ' ', 1), '-', 1) AS DECIMAL(10,2)) +
         CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(power_bhp, ' ', 1), '-', -1) AS DECIMAL(10,2))) / 2
    )
    ELSE
    
        CAST(SUBSTRING_INDEX(power_bhp, ' ', 1) AS DECIMAL(10,2))
END;
 
SELECT *,
       RANK() OVER (ORDER BY bhp_numeric DESC) AS bhp_rank
FROM cars;

SELECT brand, MAX(bhp_numeric) AS top_bhp
FROM cars
GROUP BY brand
ORDER BY top_bhp DESC;
WITH brand_bhp AS (
    SELECT brand, MAX(bhp_numeric) AS top_bhp
    FROM cars
    GROUP BY brand
)
SELECT
    brand,
    top_bhp,
    RANK() OVER (ORDER BY top_bhp DESC) AS bhp_rank
FROM brand_bhp;















    
    



 
 


















