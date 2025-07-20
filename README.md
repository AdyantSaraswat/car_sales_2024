# car_sales_2024
SQL project analyzing 2024 car sales data with insights on car count by brand, average prices, price segmentation, ranking of cars by price and power, top-selling cars, revenue-generating brands, and ranking brands by their most powerful cars.

## 📌 Objectives

- Clean and prepare raw data for accurate analysis  
- Analyze brand-wise distribution of cars  
- Identify pricing trends and power metrics  
- Segment cars into budget, mid-range, and premium  
- Identify top-selling cars in 2024 and the most revenue-generating brands  
- Rank cars within brands by price and power  


## Tools: MySQL, Kaggle Dataset

## 🛠️ SQL Features Used

- Data cleaning using `IS NULL`, `REPLACE`, and type casting  
- Aggregations with `GROUP BY`, `AVG()`, and `MAX()`  
- Conditional segmentation using `CASE`  
- Subqueries for filtering and derived logic  
- Window functions for ranking and partitioning (`RANK()`, `PARTITION BY`)  


## 🗂️ Project Structure

### 1️⃣ Database Setup
- Database creation: `car_sales`
- Table: `cars`
  - Columns: `brand`, `car_name`, `price`, `safety`, `mileage`, `power_bhp`, `sales_2024`

### 2️⃣ Cleaning of Data

<pre>
  DELETE FROM cars
WHERE TRIM(brand) = '' OR brand IS NULL
OR TRIM(car_name) = '' OR car_name IS NULL
OR TRIM(price_raw) = '' OR price_raw IS NULL

or trim(safety)= '' or safety is null
OR TRIM(mileage) = '' OR mileage IS NULL
OR TRIM(power_bhp) = '' OR power_bhp IS NULL
OR TRIM(sales_2024) = '' OR sales_2024 IS NULL;
</pre>

### 3️⃣ Count of Cars by Brand
<pre>
   select 
 brand , COUNT(*) AS total_cars
 from cars
 GROUP BY Brand
 order by total_cars desc;
</pre>

### 4️⃣ Average Price and Average Power per Brand
<pre>
  select* FROM cars;
	SELECT brand, 
    avg(price_in_lakhs) as avg_price_in_lakhs,
   avg(power_bhp) as avg_bhp 
      from cars
    group by brand 
    order by avg_price_in_lakhs desc;
</pre>

### 5️⃣ Segmenting Cars by Price (Budget, Mid-Range, Premium)  
- Ranking cars by `price` and `power_bhp`
<pre>
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
</pre>
### 6️⃣ Top Most Selling Cars (2024)
<pre>
  SELECT car_name, sales_2024
FROM cars
ORDER BY sales_2024 DESC
LIMIT 10;
</pre>

### 7️⃣ Most Revenue-Generating Brand
<pre>
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
</pre>

### 8️⃣ Brand with Most Powerful Cars
<pre>
  SELECT brand, MAX(bhp_numeric) AS top_bhp
FROM cars
GROUP BY brand
ORDER BY top_bhp DESC;
WITH brand_bhp AS (
    SELECT brand, MAX(bhp_numeric) AS top_bhp
    FROM cars
    GROUP BY brand
);


</pre>

### 9️⃣ Ranking Cars by Power (Within Brand)
<pre>
  SELECT
    brand,
    top_bhp,
    RANK() OVER (ORDER BY top_bhp DESC) AS bhp_rank
FROM brand_bhp;

</pre>

### 🔟 Top 10 Most Powerful Car-Making Brands
<pre>
  SELECT
    brand,
    car_name,
    bhp_numeric
FROM cars
WHERE bhp_numeric IS NOT NULL
ORDER BY bhp_numeric DESC
LIMIT 10;
</pre>



## 📈 Key Findings


- Average price and power vary significantly across brands, indicating clear market segmentation.
- Cars have been successfully categorized into Budget, Mid-Range, and Premium segments with car price less than  7 lakhs consider ' Budget ' where as car price range between 7 to 15 lakhs consider 'Mid Range ' and cars more than 15 lakhs of price are 'Premium'
- Top 3 most power cars are McLaren 720s with power of 711 bhp then Aston Martin DBX with power of 619.5 bhp then McLaren GT with power of 612 bhp
- McLaren , Aston Matin and Bentley have most power full cars 
- Maruti Suzuki have top selling cars with WAGON R the most seeling with 200177 units sold 
- The most revenue-generating brand in 2024 is Maruti Suzuki following with Toyota then Mahindra 
- Cars have been ranked by power within each brand to identify internal segment leaders.
- A final ranking shows the top 10 brands producing the most powerful cars overall.






