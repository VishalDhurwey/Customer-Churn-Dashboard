CREATE DATABASE olist_ecommerce;
USE olist_ecommerce;


CREATE TABLE customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_delivered_customer_date DATETIME
);

CREATE TABLE order_items (
    order_id VARCHAR(50),
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_type VARCHAR(50),
    payment_value DECIMAL(10,2)
);

CREATE TABLE products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status, 
 @order_purchase_timestamp, @order_delivered_customer_date)
SET
 order_purchase_timestamp = REPLACE(@order_purchase_timestamp, '\r', ''),
 order_delivered_customer_date = REPLACE(@order_delivered_customer_date, '\r', '');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, price, freight_value);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/payments.csv'
INTO TABLE payments
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, payment_type, payment_value);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_category_name, product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm);


SELECT MAX(order_purchase_timestamp) AS max_date FROM orders;
-- Assume the result is '2018-10-17'

CREATE OR REPLACE VIEW delivered_orders AS
SELECT *
FROM orders
WHERE order_status = 'delivered';

CREATE OR REPLACE VIEW rfm_table AS
SELECT
    c.customer_unique_id,
    MAX(o.order_purchase_timestamp) AS last_order_date,
    DATEDIFF('2018-08-29', MAX(o.order_purchase_timestamp)) AS recency,
    COUNT(DISTINCT o.order_id) AS frequency,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS monetary
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id;

CREATE OR REPLACE VIEW rfm_segmented AS
SELECT *,
    CASE
        WHEN recency <= 30 THEN 'Recent'
        WHEN recency BETWEEN 31 AND 90 THEN 'Warm'
        ELSE 'Inactive'
    END AS recency_segment,
    
    CASE
        WHEN frequency >= 5 THEN 'Frequent'
        WHEN frequency BETWEEN 2 AND 4 THEN 'Occasional'
        ELSE 'Rare'
    END AS frequency_segment,
    
    CASE
        WHEN monetary >= 1000 THEN 'High Spender'
        WHEN monetary BETWEEN 500 AND 999 THEN 'Mid Spender'
        ELSE 'Low Spender'
    END AS monetary_segment
FROM rfm_table;

CREATE OR REPLACE VIEW rfm_with_churn AS
SELECT *,
    CASE
        WHEN recency > 180 THEN 'High Risk'
        WHEN recency BETWEEN 91 AND 180 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS churn_risk
FROM rfm_segmented;

CREATE OR REPLACE VIEW final_rfm_data AS
SELECT 
    r.*,
    c.customer_state,
    c.customer_city
FROM rfm_with_churn r
JOIN customers c ON r.customer_unique_id = c.customer_unique_id;

SELECT * FROM final_rfm_data LIMIT 20;

SELECT recency_segment, frequency_segment, monetary_segment, COUNT(*) AS customer_count
FROM final_rfm_data
GROUP BY recency_segment, frequency_segment, monetary_segment
ORDER BY customer_count DESC;

SELECT *
FROM final_rfm_data
WHERE recency IS NULL OR frequency IS NULL OR monetary IS NULL;

SELECT COUNT(*) FROM final_rfm_data;
SELECT MAX(recency), MIN(recency) FROM final_rfm_data;

SELECT SUM(monetary) FROM final_rfm_data;

SELECT customer_state, SUM(monetary) as total_revenue FROM final_rfm_data GROUP BY customer_state ORDER BY total_revenue DESC LIMIT 5;

SELECT * FROM final_rfm_data;

SHOW VARIABLES LIKE 'secure_file_priv';

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/final_rfm_data.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
FROM final_rfm_data;


