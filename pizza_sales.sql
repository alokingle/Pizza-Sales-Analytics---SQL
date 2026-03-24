-- Create table pizzas

CREATE TABLE pizzas (
	pizza_id VARCHAR(50) PRIMARY KEY,
	pizza_type_id VARCHAR(50) NOT NULL,
	size VARCHAR(10) NOT NULL,
	price	NUMERIC(5,2) NOT NULL
);

-- Create table pizza_types 
CREATE TABLE pizza_types (
	pizza_type_id TEXT PRIMARY KEY,
	name TEXT NOT NULL,
	category TEXT NOT NULL,
	ingredients TEXT NOT NULL
);

-- Create table orders
CREATE TABLE orders (
	order_id INTEGER PRIMARY KEY,
	date DATE NOT NULL,
	time TIME NOT NULL
);

-- Create table order_details
CREATE TABLE order_details (
	order_details_id INTEGER PRIMARY KEY,
	order_id INTEGER NOT NULL,
	pizza_id VARCHAR(50) NOT NULL,
	quantity INTEGER NOT NULL,

	-- Foreign Keys
	CONSTRAINT fk_order
	FOREIGN KEY (order_id)
	REFERENCES orders(order_id),

	CONSTRAINT fk_pizza
	FOREIGN KEY (pizza_id)
	REFERENCES pizzas(pizza_id)
);

-- Data Exploration and Analysis

-- 1. Retrieve the total number of orders placed.

SELECT
	COUNT(order_id) AS total_orders
FROM orders;

-- 2.total orders placed per day

SELECT
    o.date,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY o.date
ORDER BY o.date;

-- 3. Calculate the total revenue generated from pizza sales.

SELECT
	ROUND(SUM(od.quantity * p.price),2) AS total_revenue
FROM pizzas p
INNER JOIN order_details od
ON p.pizza_id = od.pizza_id;

-- 4. Identify the highest-priced pizza.

SELECT
	pt.name,
	p.price
FROM pizzas p
INNER JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- 5. Identify the most common pizza size ordered.

SELECT
	p.size,
	COUNT(od.order_details_id) AS total_orders
FROM order_details od
INNER JOIN pizzas p 
ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_orders DESC;

-- 6. List the top 5 most ordered pizza types along with their quantities.

SELECT
	pt.name,
	SUM(od.quantity) AS total_pizza_quantity
FROM pizza_types pt
INNER JOIN pizzas p
ON pt.pizza_type_id = p.pizza_type_id
INNER JOIN order_details od 
ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY total_pizza_quantity DESC
LIMIT 5;

-- Intermidiate

-- 7. Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT
	pt.category,
	SUM(od.quantity) AS total_quantity
	FROM pizza_types pt
	INNER JOIN pizzas p
	ON pt.pizza_type_id = p.pizza_type_id
	INNER JOIN order_details od 
	ON p.pizza_id = od.pizza_id
	GROUP BY pt.category
	ORDER BY total_quantity DESC;

-- 8. Determine the distribution of orders by hour of the day.

SELECT
	EXTRACT(HOUR FROM time) AS hour,
	COUNT(order_id) AS order_count
FROM orders 
GROUP BY EXTRACT(HOUR FROM time)
ORDER BY order_count DESC;

-- 9. Join relevant tables to find the category-wise distribution of pizzas.

SELECT
	category,
	COUNT(name) AS total_pizza
FROM pizza_types
GROUP BY category
ORDER BY total_pizza DESC;

-- 10. list all the pizzas that has never been ordered

SELECT p.pizza_id, p.pizza_type_id, p.size, p.price
FROM pizzas p
LEFT JOIN order_details od
    ON p.pizza_id = od.pizza_id
WHERE od.pizza_id IS NULL;

-- 11. Categorize pizzas as “High”, “Medium”, “Low” revenue using CASE

WITH revenue_cte AS (
    SELECT
        pt.name,
        SUM(od.quantity * p.price) AS revenue
    FROM pizza_types pt
    JOIN pizzas p 
        ON pt.pizza_type_id = p.pizza_type_id
    JOIN order_details od 
        ON od.pizza_id = p.pizza_id
    GROUP BY pt.name
)

SELECT
    name,
    revenue,
    CASE
        WHEN revenue > 50000 THEN 'High Revenue'
        WHEN revenue BETWEEN 20000 AND 50000 THEN 'Medium Revenue'
        ELSE 'Low Revenue'
    END AS revenue_category
FROM revenue_cte
ORDER BY revenue DESC;


-- 12. Group the orders by date and calculate the average number of pizzas ordered per day.

	WITH daily_quantity AS (
    SELECT
        o.date AS order_date,
        SUM(od.quantity) AS total_quantity
    FROM order_details od
    JOIN orders o
        ON od.order_id = o.order_id
    GROUP BY o.date
)

SELECT
    ROUND(AVG(total_quantity), 0) AS avg_pizzas_ordered_per_day
FROM daily_quantity;


-- 13. Determine the top 3 most ordered pizza types based on revenue.

SELECT
	pt.name,
	SUM(od.quantity * p.price) AS revenue
FROM pizza_types pt
INNER JOIN pizzas p  
ON p.pizza_type_id = pt.pizza_type_id
INNER JOIN order_details od 
ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;

--Advance

-- 14.Calculate the percentage contribution of each pizza type to total revenue.

WITH pizza_revenue AS (
    SELECT
        pt.pizza_type_id,
        pt.name,
        SUM(od.quantity * p.price) AS revenue
    FROM pizza_types pt
    JOIN pizzas p 
        ON pt.pizza_type_id = p.pizza_type_id
    JOIN order_details od 
        ON od.pizza_id = p.pizza_id
    GROUP BY pt.pizza_type_id, pt.name
),

total_revenue AS (
    SELECT SUM(revenue) AS total_rev
    FROM pizza_revenue
)

SELECT
    pr.name AS pizza_type,
    ROUND((pr.revenue / tr.total_rev) * 100, 2) AS percentage_contribution
FROM pizza_revenue pr
CROSS JOIN total_revenue tr
ORDER BY percentage_contribution DESC;


-- 15. Analyze the cumulative revenue generated over time.

WITH daily_revenue AS (
    SELECT
        o.date AS order_date,
        SUM(od.quantity * p.price) AS revenue
    FROM order_details od
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    JOIN orders o
        ON o.order_id = od.order_id
    GROUP BY o.date
),

cumulative_revenue AS (
    SELECT
        order_date,
        revenue,
        SUM(revenue) OVER (
            ORDER BY order_date
        ) AS cum_revenue
    FROM daily_revenue
)

SELECT 
    order_date,
    cum_revenue
FROM cumulative_revenue
ORDER BY order_date;



-- 16. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

--aggrigation and filter
WITH revenue_cte AS (
    SELECT
        pt.category,
        pt.name,
        SUM(od.quantity * p.price) AS revenue
    FROM pizza_types pt
    JOIN pizzas p 
        ON pt.pizza_type_id = p.pizza_type_id
    JOIN order_details od 
        ON od.pizza_id = p.pizza_id
    GROUP BY pt.category, pt.name
),
-- rank_cte
ranked_cte AS (
    SELECT
        category,
        name,
        revenue,
        RANK() OVER (
            PARTITION BY category 
            ORDER BY revenue DESC
        ) AS rn
    FROM revenue_cte
)
--main query
SELECT 
    category,
    name,
    revenue
FROM ranked_cte
WHERE rn <= 3
ORDER BY category, revenue DESC;


--END





