-- BUSINESS QUESTION 5: Products Running Low on Stock

-- Question: Which products need to be reordered?
--           What items are below their reorder level?
--
-- Business Value:
-- This helps the CEO with inventory management:
-- - Prevent stockouts that lose sales
-- - Identify which suppliers to contact
-- - Prioritize urgent reorders
-- - Plan purchasing budget
--
-- SQL Features Used:
-- - JOIN (3 tables): products, categories, suppliers
-- - WHERE: filter products below reorder level
-- - Calculated column: units_below_reorder
-- - ORDER BY: prioritize most urgent items
-- - No GROUP BY needed (different query type for variety)


USE pawpal_db;

-- Query to find products currently below reorder level
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    s.supplier_name,
    s.email AS supplier_email,
    p.stock_quantity AS current_stock,
    p.reorder_level,
    (p.reorder_level - p.stock_quantity) AS units_below_reorder
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.stock_quantity < p.reorder_level
    AND p.is_active = TRUE
ORDER BY units_below_reorder DESC;


-- ALTERNATIVE: Products closest to needing reorder

-- If no products are currently below reorder level,
-- this query shows which ones are closest to needing reorder:

SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    s.supplier_name,
    s.email AS supplier_email,
    p.stock_quantity AS current_stock,
    p.reorder_level,
    (p.stock_quantity - p.reorder_level) AS stock_margin
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.is_active = TRUE
ORDER BY stock_margin ASC
LIMIT 10;


-- EXPECTED RESULTS INTERPRETATION:

-- The query identifies inventory that needs attention.
--
-- Key metrics:
-- - current_stock: What we have now
-- - reorder_level: Minimum safe stock level
-- - units_below_reorder: How urgently we need to order
-- - stock_margin: Buffer before we hit reorder level
--
-- Priority levels:
-- - Negative margin = URGENT, order immediately
-- - 0-10 margin = Order soon
-- - 10-20 margin = Monitor closely
-- - 20+ margin = Safe for now
--
-- Action items for the CEO:
-- 1. Contact suppliers for items below reorder level
-- 2. Set up automatic reorder alerts
-- 3. Review reorder levels - are they appropriate?
-- 4. Consider safety stock for best-selling items
-- 5. Plan cash flow for upcoming purchase orders
