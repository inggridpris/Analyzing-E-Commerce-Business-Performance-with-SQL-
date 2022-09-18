Task 1

CREATE TABLE public.customers
(
	customer_id VARCHAR,
	customer_unique_id VARCHAR,
	customer_zip_code_prefix INT,
	customer_city VARCHAR,
	customer_state VARCHAR
);

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

COPY customers
(
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
)
FROM 'C:\Program Files\PostgreSQL\14\Dataset - ecommerce\customers_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.geolocation
(
	geolocation_zip_code_prefix INT,
	geolocation_lat DECIMAL,
	geolocation_lng DECIMAL,
	geolocation_city VARCHAR,
	geolocation_state VARCHAR
);

COPY geolocation
(
	geolocation_zip_code_prefix,
	geolocation_lat,
	geolocation_lng,
	geolocation_city,
	geolocation_state
)
FROM 'C:\Program Files\PostgreSQL\14\Dataset - ecommerce\geolocation_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.order_items
(
	order_id VARCHAR,
	order_item_id SMALLINT,
	product_id VARCHAR,
	seller_id VARCHAR,
	shipping_limit_date TIMESTAMP WITHOUT TIME ZONE,
	price REAL,
	freight_value REAL
);

ALTER TABLE order_items
ADD FOREIGN KEY (order_id) REFERENCES orders(order_id),
ADD FOREIGN KEY (product_id) REFERENCES product(product_id),
ADD FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);

COPY order_items
(
	order_id,
	order_item_id,
	product_id,
	seller_id,
	shipping_limit_date,
	price,
	freight_value
)
FROM 'C:\Program Files\PostgreSQL\14\Dataset - ecommerce\order_items_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.order_payments
(
	order_id VARCHAR,
	payment_sequential SMALLINT,
	payment_type VARCHAR,
	payment_installments SMALLINT,
	payment_value REAL
);

ALTER TABLE order_payments
ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);

COPY order_payments
(
	order_id,
	payment_sequential,
	payment_type,
	payment_installments,
	payment_value
)
FROM 'C:\Program Files\PostgreSQL\14\Dataset - ecommerce\order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.order_reviews
(
	review_id VARCHAR,
	order_id VARCHAR,
	review_score SMALLINT,
	review_comment_title VARCHAR,
	review_comment_message VARCHAR,
	review_creation_date TIMESTAMP WITHOUT TIME ZONE,
	review_answer_timestamp TIMESTAMP WITHOUT TIME ZONE
	
);

ALTER TABLE order_reviews
ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);


COPY order_reviews
(
	review_id,
	order_id,
	review_score,
	review_comment_title,
	review_comment_message,
	review_creation_date,
	review_answer_timestamp
)
FROM 'C:\Program Files\PostgreSQL\14\Dataset - ecommerce\order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.orders
(
	order_id VARCHAR,
	customer_id VARCHAR,
	order_status VARCHAR,
	order_purchase_timestamp TIMESTAMP WITHOUT TIME ZONE,
	order_approved_at TIMESTAMP WITHOUT TIME ZONE,
	order_delivered_carrier_date TIMESTAMP WITHOUT TIME ZONE,
	order_delivered_customer_date TIMESTAMP WITHOUT TIME ZONE,
	order_estimated_delivery_date TIMESTAMP WITHOUT TIME ZONE
);

ALTER TABLE orders
ADD PRIMARY KEY (order_id);

ALTER TABLE orders
ADD FOREIGN KEY (customer_id) REFERENCES customers (customer_id);


COPY orders
(
	order_id,
	customer_id,
	order_status,
	order_purchase_timestamp,
	order_approved_at,
	order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivery_date
)
FROM 'C:\Program Files\PostgreSQL\14\Dataset - ecommerce\orders_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.product
(
	fnc_num INT,
	product_id VARCHAR,
	product_category_name VARCHAR,
	product_name_lenght VARCHAR,
	product_description_lenght REAL,
	product_photos_qty REAL,
	product_weight_g REAL,
	product_length_cm REAL,
	product_height_cm REAL,
	product_width_cm REAL
);

ALTER TABLE product
ADD PRIMARY KEY (product_id);

COPY product
(
	fnc_num,
	product_id,
	product_category_name,
	product_name_lenght,
	product_description_lenght,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
)
FROM 'C:\Program Files\PostgreSQL\14\Dataset - ecommerce\product_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.sellers
(
	seller_id VARCHAR,
	seller_zip_code_prefix INT,
	seller_city VARCHAR,
	seller_state VARCHAR
);

ALTER TABLE sellers
ADD PRIMARY KEY (seller_id);

COPY sellers
(
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
)
FROM 'C:\Program Files\PostgreSQL\14\Dataset - ecommerce\sellers_dataset.csv'
DELIMITER ','
CSV HEADER;

Task 2 

soal 1
SELECT 
	year,
	round(AVG(custac),2) as average_custac
FROM (
	SELECT
 		DATE_PART('YEAR',o.order_purchase_timestamp) as year,
 		DATE_PART('MONTH',o.order_purchase_timestamp) as month,
 		COUNT (distinct c.customer_unique_id) as custac
	FROM orders o
	join customers c
		on o.customer_id = c.customer_id
	group by 1,2
	) subq
group by 1;
	
soal 2
SELECT
	year,
	COUNT(customer_unique_id) as new_cust
FROM(
		SELECT
		MIN(DATE_PART('YEAR',o.order_purchase_timestamp)) as year,
		c.customer_unique_id			
		FROM orders o
		JOIN customers c
		on o.customer_id = c.customer_id
		GROUP BY 2
			) ssd
GROUP BY 1
ORDER BY year asc;

soal 3
SELECT
	year,
	count(ext_cus) as repeat_cus
FROM(
		SELECT
		DATE_PART('YEAR', o.order_purchase_timestamp) as year,
		count(c.customer_unique_id) as ext_cus,
		c.customer_unique_id
		FROM orders o
		JOIN customers c
		on o.customer_id = c.customer_id
		GROUP BY 1,3
			) ssd
WHERE ext_cus > 1
GROUP BY 1
ORDER BY year asc;

Soal 4
SELECT
	year,
	avg(ext_cus) as avg_pemb
FROM(
		SELECT
		DATE_PART('YEAR', o.order_purchase_timestamp) as year,
		count(c.customer_unique_id) as ext_cus,
		c.customer_unique_id
		FROM orders o
		JOIN customers c
		on o.customer_id = c.customer_id
		GROUP BY 1,3
			) ssd
GROUP BY 1
ORDER BY year asc;

gabungan tabel task 2

WITH avg_cus as (
SELECT 
	year,
	round(AVG(custac),2) as average_custac
FROM (
	SELECT
 		DATE_PART('YEAR',o.order_purchase_timestamp) as year,
 		DATE_PART('MONTH',o.order_purchase_timestamp) as month,
 		COUNT (distinct c.customer_unique_id) as custac
	FROM orders o
	join customers c
		on o.customer_id = c.customer_id
	group by 1,2
	) subq
group by 1),

new_cust AS (SELECT
	year,
	COUNT(customer_unique_id) as new_cust
FROM(
		SELECT
		MIN(DATE_PART('YEAR',o.order_purchase_timestamp)) as year,
		c.customer_unique_id			
		FROM orders o
		JOIN customers c
		on o.customer_id = c.customer_id
		GROUP BY 2
			) ssd
GROUP BY 1
ORDER BY year asc),

repeat_cus AS (SELECT
	year,
	count(ext_cus) as repeat_cus
FROM(
		SELECT
		DATE_PART('YEAR', o.order_purchase_timestamp) as year,
		count(c.customer_unique_id) as ext_cus,
		c.customer_unique_id
		FROM orders o
		JOIN customers c
		on o.customer_id = c.customer_id
		GROUP BY 1,3
			) ssd
WHERE ext_cus > 1
GROUP BY 1
ORDER BY year asc),

avg_pemb AS (SELECT
	year,
	avg(ext_cus) as avg_pemb
FROM(
		SELECT
		DATE_PART('YEAR', o.order_purchase_timestamp) as year,
		count(c.customer_unique_id) as ext_cus,
		c.customer_unique_id
		FROM orders o
		JOIN customers c
		on o.customer_id = c.customer_id
		GROUP BY 1,3
			) ssd
GROUP BY 1
ORDER BY year asc)

SELECT a.year, a.average_custac, n.new_cust, r.repeat_cus, p.avg_pemb
FROM avg_cus as a
Join new_cust as n on n.year=a.year
JOIN repeat_cus as r on r.year=a.year
JOIN avg_pemb as p on p.year=a.year;

Task 3
soal 1
DROP TABLE revenue

CREATE TABLE REVENUE AS
SELECT 
	year,
	Revenue,
	order_status
FROM(
	Select 
		sum(oi.price+oi.freight_value) as Revenue,
		DATE_PART('YEAR',o.order_purchase_timestamp) as year,
		o.order_status
	FROM orders o
		JOIN order_items oi
		on o.order_id = oi.order_id
	GROUP BY 2,3
		) dcd
WHERE order_status in ('delivered')
GROUP BY 1,2,3
ORDER BY (year) ASC;

ALTER TABLE revenue
RENAME column order_status to revenue;

Soal 2
CREATE TABLE cancel_order AS
SELECT
	DATE_PART('YEAR',order_purchase_timestamp) as year,
	count(order_status) as canceled
FROM orders
WHERE ordpublic.cancel_orderer_status in ('canceled')
GROUP BY 1
ORDER BY (year) ASC;

soal 3
CREATE TABLE top_category AS
SELECT 
	year,
	rank,
	product_category_name
FROM (
		SELECT 
			product_category_name,
			year,
			pendapatan,
			rank() over(partition by year ORDER BY pendapatan DESC)
		FROM(
				SELECT
					product_category_name,
					DATE_PART('YEAR',o.order_purchase_timestamp) as year,
					sum(oi.price+oi.freight_value) as pendapatan
				FROM order_items as oi
				JOIN product as p on oi.product_id = p.product_id
				JOIN orders as o on oi.order_id = o.order_id
				GROUP BY 1,2
				)ass
			GROUP BY 1,2,3) ast
WHERE rank=1
GROUP BY 1,2,3
ORDER BY year ASC;

soal 4
CREATE TABLE top_category_cancel AS
SELECT 
	year,
	rank,
	product_category_name
FROM (
		SELECT 
			product_category_name,
			year,
			batal,
			rank() over(partition by year ORDER BY batal DESC)
		FROM(
				SELECT
					product_category_name,
					DATE_PART('YEAR',o.order_purchase_timestamp) as year,
					count(order_status) as batal
				FROM order_items as oi
				JOIN product as p on oi.product_id = p.product_id
				JOIN orders as o on oi.order_id = o.order_id
				WHERE order_status in ('canceled')
				GROUP BY 1,2
				)ase
			GROUP BY 1,2,3) asw
WHERE rank=1
GROUP BY 1,2,3
ORDER BY year ASC;

gabungan semua task 3

SELECT 
	r.year,
	r.revenue,
	tp.product_category_name,
	tcc.product_category_name,
	co.canceled
FROM revenue as r
JOIN top_category as tp on r.year=tp.year
JOIN top_category_cancel as tcc on r.year=tcc.year
JOIN cancel_order as co on r.year=co.year;

TASK 4
soal 1
SELECT
	op.payment_type,
	count(o.order_id) as total
FROM orders as o
JOIN order_payments as op on o.order_id = op.order_id
GROUP BY 1

soal 2
SELECT 
	payment_type,
	count(CASE WHEN (DATE_PART('YEAR',o.order_purchase_timestamp)) ='2016' then 1 ELSE Null
	END) AS "payment_2016",
	count(CASE WHEN (DATE_PART('YEAR',o.order_purchase_timestamp))='2017' then 2 ELSE Null
	END) AS "payment_2017",
	count(CASE WHEN (DATE_PART('YEAR',o.order_purchase_timestamp))='2018' then 3 ELSE Null
	END) AS "payment_2018"
FROM orders as o
JOIN order_payments as op on o.order_id = op.order_id
GROUP BY 1
ORDER BY payment_type ASC;