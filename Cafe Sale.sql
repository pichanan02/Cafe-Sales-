-- #### Cafe Sales ####--

SELECT *
FROM customers;

SELECT *
FROM invoices;

SELECT *
FROM items;
-----------

-- 1. Find the total sales of each product. Sort by product ID
SELECT
    items.item_id,
    items.item_name,
    SUM(invoices.quantity * items.price) AS total_sale
FROM items
INNER JOIN invoices
ON items.item_id = invoices.item_id
GROUP BY items.item_id, item_name
ORDER BY items.item_id;


-- 2. Find the cumulative sales of each customer. Sort by highest to lowest cumulative sales.
SELECT invoices.customer_id,
       SUM(invoices.quantity * items.price) AS total_sales
FROM invoices
JOIN items
ON invoices.item_id = items.item_id
GROUP BY customer_id
ORDER BY total_sales DESC;


-- 3.Classify products as Dairy Products or Non-Dairy Products.
-- Retrieve all data from the Items table and create product_category.
-- Provided that if item_id consists of 3, 4, 5, 8 and 9, then record it as Dairy Product. Otherwise, record it as Non-Dairy Product.
SELECT
    *,
    CASE
        WHEN item_id IN (3, 4, 5, 8, 9) THEN 'Dairy Product'
        ELSE 'Non-Dairy Product'
        END AS product_category
FROM items;


-- 4.Calculate sales of Dairy Products and Non-Dairy Products and find the proportion of sales of both products.
WITH ProductCategories AS (
SELECT
    *,
    CASE
        WHEN item_id IN (3, 4, 5, 8, 9) THEN 'Dairy Product'
        ELSE 'Non-Dairy Product'
        END AS product_category
FROM items)

SELECT
    ProductCategories.product_category,
    SUM(invoices.quantity) AS quantity_sold,
    SUM(invoices.quantity) * 100 / (SELECT SUM(quantity) FROM invoices) AS percentage_sold
    --ProductCategories.price * invoices.quantity AS total_sales
FROM ProductCategories
JOIN invoices
    ON ProductCategories.item_id = invoices.item_id
GROUP BY ProductCategories.product_category


-- 5. Calculate total sales for each day of the week (Sunday to Saturday)
SELECT
    CASE EXTRACT(DOW FROM invoices.order_date)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS day_of_week,
    SUM(invoices.quantity * items.price) AS total_sales
FROM invoices
JOIN items
    ON invoices.item_id = items.item_id
GROUP BY day_of_week;


-- 6. Calculate total sales for each day of the week classified by Dairy and Non dairy products.
WITH ProductCategories AS (
SELECT
    *,
    CASE
        WHEN item_id IN (3, 4, 5, 8, 9) THEN 'Dairy Product'
        ELSE 'Non-Dairy Product'
        END AS product_category
FROM items),


InvoicesWithDayName AS (
SELECT
    *,
    CASE EXTRACT(DOW FROM invoices.order_date)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS day_of_week
FROM invoices)

SELECT
    day_of_week,
    product_category,
    SUM(quantity * price) AS total_sales
FROM InvoicesWithDayName
JOIN ProductCategories
    ON InvoicesWithDayName.item_id = ProductCategories.item_id
GROUP BY day_of_week, product_category
ORDER BY day_of_week;