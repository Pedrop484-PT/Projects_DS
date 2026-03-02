
-- BUSINESS QUESTION 3: Top 5 Customers by Total Spending

-- Question: Who are our VIP customers? Who spends the most?

-- Business Value:
-- This helps the CEO identify high-value customers for:
-- - Loyalty program targeting
-- - Personalized marketing campaigns
-- - Customer retention strategies
-- - Understanding customer lifetime value
--
-- SQL Features Used:
-- - JOIN (3 tables): customers, orders, order_details
-- - GROUP BY: aggregate by customer
-- - CONCAT(): combine first and last names
-- - COUNT(DISTINCT): count unique orders per customer
-- - SUM() and AVG(): calculate total spent and average order value
-- - ROUND(): format decimal numbers
-- - ORDER BY with LIMIT: get top 5 spenders

USE pawpal_db;

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(od.quantity * od.unit_price * (1 - od.discount/100)), 2) AS total_spent,
    ROUND(AVG(od.quantity * od.unit_price * (1 - od.discount/100)), 2) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY total_spent DESC
LIMIT 5;


-- EXPECTED RESULTS INTERPRETATION:

-- The query identifies our most valuable customers.
--
-- Key metrics explained:
-- - total_orders: How frequently they shop with us
-- - total_spent: Their lifetime value so far
-- - avg_order_value: How much they spend per transaction
--
-- A customer with high total_spent but few orders = big spender
-- A customer with many orders but lower total = frequent small buyer
--
-- Action items for the CEO:
-- 1. Create VIP loyalty rewards for top spenders
-- 2. Send personalized thank-you messages
-- 3. Offer early access to new products
-- 4. Consider free shipping for VIP customers
-- 5. Analyze what products VIP customers buy (for cross-selling)

