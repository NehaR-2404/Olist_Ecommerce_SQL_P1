-- SECTION A: DATA STAGING, CLEANING AND IMPORT


-- Always import into _raw right after creating it.
-- Then run the clean CREATE TABLE ... and INSERT ....
-- This guarantees no errors (missing values → NULL, duplicates removed).

-- Create staging table
CREATE TABLE customers_raw (
  customer_id TEXT,
  customer_unique_id TEXT,
  customer_zip_code_prefix TEXT,
  customer_city TEXT,
  customer_state TEXT
);

-- Import "olist_customers_dataset.csv" into customers_raw using pgAdmin Import/Export tool

-- Create final table
CREATE TABLE customers (
  customer_id TEXT PRIMARY KEY,
  customer_unique_id TEXT,
  customer_zip_code_prefix TEXT,
  customer_city TEXT,
  customer_state TEXT
);

-- Move cleaned data
INSERT INTO customers
SELECT DISTINCT * FROM customers_raw;

-- Staging Orders
-- Creating Raw Table
CREATE TABLE orders_raw (
  order_id TEXT,
  customer_id TEXT,
  order_status TEXT,
  order_purchase_timestamp TEXT,
  order_approved_at TEXT,
  order_delivered_carrier_date TEXT,
  order_delivered_customer_date TEXT,
  order_estimated_delivery_date TEXT
);

-- Import "olist_orders_dataset.csv" into orders_raw

CREATE TABLE orders (
  order_id TEXT PRIMARY KEY,
  customer_id TEXT REFERENCES customers(customer_id),
  order_status TEXT,
  order_purchase_timestamp TIMESTAMP,
  order_approved_at TIMESTAMP,
  order_delivered_carrier_date TIMESTAMP,
  order_delivered_customer_date TIMESTAMP,
  order_estimated_delivery_date TIMESTAMP
);

--Inserted cleaned data
INSERT INTO orders
SELECT DISTINCT
  order_id,
  customer_id,
  order_status,
  NULLIF(order_purchase_timestamp,'')::TIMESTAMP,
  NULLIF(order_approved_at,'')::TIMESTAMP,
  NULLIF(order_delivered_carrier_date,'')::TIMESTAMP,
  NULLIF(order_delivered_customer_date,'')::TIMESTAMP,
  NULLIF(order_estimated_delivery_date,'')::TIMESTAMP
FROM orders_raw;

-- Staging Order_items
CREATE TABLE order_items_raw (
  order_id TEXT,
  order_item_id TEXT,
  product_id TEXT,
  seller_id TEXT,
  shipping_limit_date TEXT,
  price TEXT,
  freight_value TEXT
);

-- Import "olist_order_items_dataset.csv" into order_items_raw

CREATE TABLE order_items (
  order_id TEXT REFERENCES orders(order_id),
  order_item_id INTEGER,
  product_id TEXT,
  seller_id TEXT,
  shipping_limit_date TIMESTAMP,
  price NUMERIC,
  freight_value NUMERIC,
  PRIMARY KEY(order_id, order_item_id)
);

-- Inserted data
INSERT INTO order_items
SELECT
  order_id,
  order_item_id::INTEGER,
  product_id,
  seller_id,
  NULLIF(shipping_limit_date,'')::TIMESTAMP,
  NULLIF(price,'')::NUMERIC,
  NULLIF(freight_value,'')::NUMERIC
FROM order_items_raw;

-- Staging Order_Payments
CREATE TABLE order_payments_raw (
  order_id TEXT,
  payment_sequential TEXT,
  payment_type TEXT,
  payment_installments TEXT,
  payment_value TEXT
);

-- Import "olist_order_payments_dataset.csv" into order_payments_raw

CREATE TABLE order_payments (
  order_id TEXT REFERENCES orders(order_id),
  payment_sequential INTEGER,
  payment_type TEXT,
  payment_installments INTEGER,
  payment_value NUMERIC
);

-- Inserted cleaned data
INSERT INTO order_payments
SELECT
  order_id,
  payment_sequential::INTEGER,
  payment_type,
  NULLIF(payment_installments,'')::INTEGER,
  NULLIF(payment_value,'')::NUMERIC
FROM order_payments_raw;

-- Staging Order_Reviews
CREATE TABLE order_reviews_raw (
  review_id TEXT,
  order_id TEXT,
  review_score TEXT,
  review_comment_title TEXT,
  review_comment_message TEXT,
  review_creation_date TEXT,
  review_answer_timestamp TEXT
);

-- Import "olist_order_reviews_dataset.csv" into order_reviews_raw

CREATE TABLE order_reviews (
  review_id TEXT PRIMARY KEY,
  order_id TEXT REFERENCES orders(order_id),
  review_score INTEGER,
  review_comment_title TEXT,
  review_comment_message TEXT,
  review_creation_date TIMESTAMP,
  review_answer_timestamp TIMESTAMP
);

-- Deduplicate: keep latest review per review_id
INSERT INTO order_reviews
SELECT DISTINCT ON (review_id)
  review_id,
  order_id,
  NULLIF(review_score,'')::INTEGER,
  review_comment_title,
  review_comment_message,
  NULLIF(review_creation_date,'')::TIMESTAMP,
  NULLIF(review_answer_timestamp,'')::TIMESTAMP
FROM order_reviews_raw
ORDER BY review_id, review_answer_timestamp DESC;

-- Staging Products

CREATE TABLE products (
  product_id TEXT PRIMARY KEY,
  product_category_name TEXT,
  product_name_lenght INTEGER,
  product_description_lenght INTEGER,
  product_photos_qty INTEGER,
  product_weight_g INTEGER,
  product_length_cm INTEGER,
  product_height_cm INTEGER,
  product_width_cm INTEGER
);

-- Inserted data
INSERT INTO products
SELECT
  product_id,
  product_category_name,
  NULLIF(product_name_lenght,'')::INTEGER,
  NULLIF(product_description_lenght,'')::INTEGER,
  NULLIF(product_photos_qty,'')::INTEGER,
  NULLIF(product_weight_g,'')::INTEGER,
  NULLIF(product_length_cm,'')::INTEGER,
  NULLIF(product_height_cm,'')::INTEGER,
  NULLIF(product_width_cm,'')::INTEGER
FROM products_raw;

-- Staging Sellers
CREATE TABLE sellers_raw (
  seller_id TEXT,
  seller_zip_code_prefix TEXT,
  seller_city TEXT,
  seller_state TEXT
);

-- Import "olist_sellers_dataset.csv" into sellers_raw

CREATE TABLE sellers (
  seller_id TEXT PRIMARY KEY,
  seller_zip_code_prefix TEXT,
  seller_city TEXT,
  seller_state TEXT
);
-- Inserted data
INSERT INTO sellers
SELECT DISTINCT * FROM sellers_raw;

-- Staging geolocation
CREATE TABLE geolocation_raw (
  geolocation_zip_code_prefix TEXT,
  geolocation_lat TEXT,
  geolocation_lng TEXT,
  geolocation_city TEXT,
  geolocation_state TEXT
);

-- Import "olist_geolocation_dataset.csv" into geolocation_raw

CREATE TABLE geolocation (
  geolocation_zip_code_prefix TEXT,
  geolocation_lat NUMERIC,
  geolocation_lng NUMERIC,
  geolocation_city TEXT,
  geolocation_state TEXT
);
-- Inserted data
INSERT INTO geolocation
SELECT
  geolocation_zip_code_prefix,
  NULLIF(geolocation_lat,'')::NUMERIC,
  NULLIF(geolocation_lng,'')::NUMERIC,
  geolocation_city,
  geolocation_state
FROM geolocation_raw;

-- Staging product category name translation

CREATE TABLE product_category_name_translation_raw (
  product_category_name TEXT,
  product_category_name_english TEXT
);

-- Import "product_category_name_translation.csv" into product_category_name_translation_raw

CREATE TABLE product_category_name_translation (
  product_category_name TEXT PRIMARY KEY,
  product_category_name_english TEXT
);
-- Inserted data
INSERT INTO product_category_name_translation (product_category_name, product_category_name_english)
SELECT DISTINCT product_category_name, product_category_name -- placeholder
FROM products
WHERE product_category_name IS NOT NULL
  AND product_category_name NOT IN (SELECT product_category_name FROM product_category_name_translation);


-- Adding relatinships among tables to enfore integrity

-- Add FK between products and order_items
ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_products
FOREIGN KEY (product_id) REFERENCES products(product_id);

-- Add FK between sellers and order_items
ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_sellers
FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);

-- Add FK between products and product_category_name_translation
ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (product_category_name)
REFERENCES product_category_name_translation(product_category_name);


-- SECTION B: BASIC QUERY ANALYSIS


-- Q1. How many unique customers placed an order each year?
-- Insight: Measures customer growth over time

SELECT 
    EXTRACT(YEAR FROM order_purchase_timestamp) AS order_year,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
GROUP BY order_year
ORDER BY order_year;

-- Q2. What percentage of orders were delivered late vs. on time?
-- Insight: Evaluates delivery efficiency

SELECT 
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
    COUNT(order_id) AS total_orders,
	SUM(CASE
	       WHEN order_delivered_customer_date :: DATE <= order_estimated_delivery_date :: DATE 
		   THEN 1 
	       ELSE 0
	    END) AS on_time_orders,
	SUM(CASE
	       WHEN order_delivered_customer_date :: DATE > order_estimated_delivery_date :: DATE 
		   THEN 1 
	       ELSE 0
	    END) AS late_orders,
    ROUND(100.0 * SUM(CASE WHEN order_delivered_customer_date::DATE <= order_estimated_delivery_date::DATE THEN 1 ELSE 0 END) / COUNT(*),
        2) AS pct_on_time,
    ROUND(100.0* SUM(CASE WHEN order_delivered_customer_date :: DATE > order_estimated_delivery_date :: DATE THEN 1 ELSE 0 END)/ COUNT(*),2) AS pct_late
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM order_purchase_timestamp);

-- Q3. What is the average number of items per order?
-- Insight: Shows typical order size trends over years

SELECT 
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
    ROUND(AVG(oi_per_order.item_count), 2) AS avg_items_per_order
FROM (
    SELECT 
        order_id,
        COUNT(*) AS item_count
    FROM order_items
    GROUP BY order_id
) oi_per_order
JOIN orders o ON oi_per_order.order_id = o.order_id
GROUP BY year
ORDER BY year;

-- Q4: Top product categories by total revenue
-- Insight: Identifies most profitable categories

SELECT
    p.product_category_name, 
	SUM(O.price + O.freight_value) AS total_revenue 
FROM order_items O
Join products p
on O.product_id =p.product_id
GROUP BY product_category_name
ORDER BY 2 DESC;

-- Q5: Average delivery time per state
-- Insight: Shows states with fastest and slowest delivery

SELECT C.customer_state,
       AVG(O.order_delivered_customer_date::date - O.order_purchase_timestamp::date) AS avg_delivery_days
FROM orders O
JOIN customers C
ON O.customer_id=C.customer_id
WHERE 
  O.order_delivered_customer_date IS NOT NULL
GROUP BY C.customer_state
ORDER BY 2 DESC;

-- Q6.What is the average review score by product category?

SELECT 
    p.product_category_name, 
    ROUND(AVG(R.review_score),2) AS avg_rating 
FROM order_reviews R
JOIN order_items O
ON R.order_id=O.order_id
JOIN products p
ON O.product_id = p.product_id 
WHERE 
    R.review_score IS NOT NULL
GROUP BY p.product_category_name
ORDER BY 2 DESC;

-- SECTION C: ADVANCED QUERY ANALYSIS

-- Q7: Top 3 best-selling products per category (by revenue)
-- Insight: Shows which products generate the most revenue within each category

WITH top_selling_products AS
(

   SELECT 
       p.product_category_name, 
	   O.product_id,
       SUM(O.price + O.freight_value) AS total_revenue,
       RANK() OVER(PARTITION BY p.product_category_name ORDER BY SUM(O.price + O.freight_value) DESC) AS rank
   FROM order_items O
   JOIN products p
   ON O.product_id=p.product_id
   WHERE 
       O.price IS NOT NULL 
	   AND 
	   O.freight_value IS NOT NULL
   GROUP BY p.product_category_name, O.product_id

)
SELECT 
    product_category_name, 
	total_revenue 
FROM top_selling_products
WHERE rank BETWEEN 1 AND 3
ORDER BY product_category_name, rank;

-- Q8: Track monthly revenue growth and calculate MoM %
-- Insight: Measures month-over-month revenue trends and growth rates

WITH monthly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY year, month
)
SELECT
    year,
    month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY year, month) AS prev_month_revenue,
    ROUND(
        100.0 * (total_revenue - LAG(total_revenue) OVER (ORDER BY year, month)) 
        / NULLIF(LAG(total_revenue) OVER (ORDER BY month), 0),
        2
    ) AS mom_growth_pct
FROM monthly_revenue
ORDER BY year, month;

-- Q9: Top 5 sellers with highest average review score (min 50 orders)
-- Insight: Highlights top-performing sellers

SELECT 
     S.seller_id, 
	 ROUND(AVG(R.review_score), 2)AS avg_rating
FROM order_reviews R
JOIN 
    order_items O 
	ON 
	R.order_id = O.order_id
JOIN 
    sellers S 
	ON 
	O.seller_id = S.seller_id
JOIN 
    orders O2 
	ON 
	R.order_id = O2.order_id
WHERE 
    R.review_score IS NOT NULL 
	AND 
	O2.order_status = 'delivered'
GROUP BY S.seller_id
HAVING COUNT(O.order_item_id) >= 50
ORDER BY avg_rating DESC
LIMIT 5;

-- Q10: Rank sellers within each state based on total sales and avg rating
-- Insight: Compares seller performance regionally

WITH seller_performance AS (
    SELECT
        s.seller_id,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        AVG(R.review_score) AS avg_rating,
        AVG(o.order_delivered_customer_date::date - o.order_purchase_timestamp::date) AS avg_delivery_days,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM sellers s
    JOIN 
	    order_items oi 
		ON 
		s.seller_id = oi.seller_id
    JOIN 
	    orders o 
		ON 
		oi.order_id = o.order_id
    LEFT JOIN 
	    order_reviews R 
		ON 
		oi.order_id = R.order_id
    GROUP BY s.seller_id
)
SELECT
    seller_id,
    total_orders,
    avg_rating,
    avg_delivery_days,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    RANK() OVER (ORDER BY avg_rating DESC NULLS LAST) AS rating_rank,
    RANK() OVER (ORDER BY avg_delivery_days ASC NULLS LAST) AS delivery_rank
FROM seller_performance
ORDER BY revenue_rank
LIMIT 10;

	   
-- Q11: 7-day moving average of daily sales revenue
-- Insight: Smooths daily revenue to identify trends and fluctuations

WITH daily_sales AS (
    SELECT
        order_purchase_timestamp::date AS order_date,
        SUM(price + freight_value) AS daily_revenue
    FROM order_items oi
    JOIN 
	    orders o
		ON 
		oi.order_id = o.order_id
    GROUP BY order_date
)
SELECT
    order_date,
    daily_revenue,
    ROUND(AVG(daily_revenue) OVER (
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2
    ) AS moving_avg_7days
FROM daily_sales
ORDER BY order_date;

-- Q12: Customers inactive for last 6 months of 2018
-- Insight: Helps detect potential churn and prior activity of inactive

WITH last_order AS (
    SELECT
        customer_id,
        MAX(order_purchase_timestamp) AS last_order_date
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    last_order_date,
    CASE
        WHEN last_order_date < '2018-07-01' THEN 'Potential Churn'
        ELSE 'Active'
    END AS status
FROM last_order
ORDER BY last_order_date;

-- Q13: Rank sellers by delivery performance (early delivery)
-- Insight: Shows sellers who consistently deliver earlier than estimated

SELECT
    s.seller_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(CASE 
            WHEN o.order_delivered_customer_date < o.order_estimated_delivery_date THEN 1 ELSE 0 
        END) AS early_deliveries,
    ROUND(100.0 * SUM(CASE 
                          WHEN o.order_delivered_customer_date < o.order_estimated_delivery_date THEN 1 ELSE 0 
                      END) / COUNT(DISTINCT oi.order_id), 2) AS early_delivery_pct,
    ROUND(AVG(o.order_estimated_delivery_date::date - o.order_delivered_customer_date::date), 2) AS avg_days_early,
    RANK() OVER (ORDER BY ROUND(100.0 * SUM(CASE 
                          WHEN o.order_delivered_customer_date < o.order_estimated_delivery_date 
                          THEN 1 
                          ELSE 0 
                      END) / COUNT(DISTINCT oi.order_id), 2) DESC) AS delivery_rank
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY s.seller_id
ORDER BY delivery_rank
LIMIT 10;

-- Q14: Top 10 customers by total spending and their average review score
-- Insight: Identifies high-value customers and their satisfaction levels

WITH customer_spending AS (
    SELECT
        o.customer_id,
        SUM(oi.price + oi.freight_value) AS total_spent,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
),
customer_reviews AS (
    SELECT
        o.customer_id,
        ROUND(AVG(r.review_score),2) AS avg_review_score
    FROM orders o
    JOIN order_reviews r ON o.order_id = r.order_id
    GROUP BY o.customer_id
)
SELECT
    cs.customer_id,
    cs.total_spent,
    cs.total_orders,
    COALESCE(cr.avg_review_score, 0) AS avg_review_score
FROM customer_spending cs
LEFT JOIN customer_reviews cr ON cs.customer_id = cr.customer_id
ORDER BY cs.total_spent DESC
LIMIT 10;

-- Q15: Product categories with highest cancellation rate
-- Insight: Identifies categories prone to returns/cancellations

WITH category_orders AS (
    SELECT
        p.product_category_name,
        COUNT(oi.order_id) AS total_orders,
        SUM(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) AS canceled_orders
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY p.product_category_name
)
SELECT
    product_category_name,
    total_orders,
    canceled_orders,
    ROUND(100.0 * canceled_orders / total_orders, 2) AS cancellation_pct
FROM category_orders
ORDER BY cancellation_pct DESC
LIMIT 10;

-- Q16: Top 10 Customer Cities by Revenue (Geolocation)
-- Description: Shows the cities and states generating the highest total revenue.

SELECT 
    g.geolocation_city,
    g.geolocation_state,
    SUM(oi.price + oi.freight_value) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(oi.price + oi.freight_value), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN geolocation g ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
WHERE o.order_status = 'delivered'
GROUP BY g.geolocation_city, g.geolocation_state
ORDER BY total_revenue DESC
LIMIT 10;

-- Q17: Average Delivery Time by Customer City (Geolocation)
-- Description: Calculates average delivery time in days per city to identify fastest/slowest delivery regions.

SELECT 
    g.geolocation_city,
    g.geolocation_state,
    ROUND(AVG(o.order_delivered_customer_date::date - o.order_purchase_timestamp::date), 2) AS avg_delivery_days,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN geolocation g ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY g.geolocation_city, g.geolocation_state
ORDER BY avg_delivery_days ASC
LIMIT 15;

-- Q18: Top 5 Products by Revenue in Each English Product Category
-- Description: Shows top products per category using translated English category names for clarity.

WITH ranked_english_products AS (
    SELECT
        t.product_category_name_english AS category,
        p.product_id,
        SUM(oi.price + oi.freight_value) AS total_revenue,
        RANK() OVER(PARTITION BY t.product_category_name_english 
                    ORDER BY SUM(oi.price + oi.freight_value) DESC) AS rank
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN product_category_name_translation t 
        ON p.product_category_name = t.product_category_name
    GROUP BY t.product_category_name_english, p.product_id
)
SELECT 
    category, 
    product_id, 
    total_revenue
FROM ranked_english_products
WHERE rank <= 5
ORDER BY category, total_revenue DESC;








