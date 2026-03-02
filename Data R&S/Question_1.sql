-- BUSINESS QUESTION 1: Top 5 Best-Selling Products

-- Question: What are our best-selling products by quantity sold?
--
-- Business Value: 
-- This helps the CEO identify popular products for:
-- - Inventory planning (ensure stock for top sellers)
-- - Marketing focus (promote what sells)
-- - Supplier negotiations (bulk discounts for popular items)
--
-- SQL Features Used:
-- - JOIN (3 tables): products, order_details, categories
-- - GROUP BY: aggregate sales by product
-- - SUM(): calculate total quantity and revenue
-- - ORDER BY with LIMIT: get top 5

USE pawpal_db;

SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(od.quantity) AS total_quantity_sold,
    ROUND(SUM(od.quantity * od.unit_price * (1 - od.discount/100)), 2) AS total_revenue
FROM products p
JOIN order_details od ON p.product_id = od.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY total_quantity_sold DESC
LIMIT 5;


-- EXPECTED RESULTS INTERPRETATION:

-- The query shows which products sell the most units.
-- For example, if "Gourmet Cat Pâté 12-pack" appears at the top,
-- it means cat owners are our most active buyers.
-- 
-- Action items for the CEO:
-- 1. Ensure adequate stock of top sellers
-- 2. Consider bundle promotions with top products
-- 3. Negotiate better prices with suppliers for high-volume items

