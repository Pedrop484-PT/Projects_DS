
-- PawPal Pet Supplies - Invoice Views

-- This file contains two views to generate invoices:
-- 1. vw_invoice_header - Order summary with totals (top part of invoice)
-- 2. vw_invoice_details - Individual line items (middle part of invoice)
--
-- IMPORTANT: The invoice is GENERATED from data in other tables using views.
-- It is NOT stored as a separate table. This is the correct approach.


USE pawpal_db;


-- VIEW 1: Invoice Header and Totals

-- Purpose: Shows order summary with calculated totals - like the top part of an invoice
--
-- What it calculates:
-- - subtotal: sum of (quantity × price) for all items
-- - total_discount: sum of discounts applied
-- - net_total: subtotal minus discounts
-- - tax_amount: 23% VAT (Portuguese tax rate)
-- - grand_total: net_total + tax

-- JOINs used:
-- - orders → customers (to get customer info)
-- - orders → order_details (to calculate totals)

CREATE OR REPLACE VIEW vw_invoice_header AS
SELECT 
    -- Invoice identification
    o.order_id AS invoice_number,
    o.order_date AS invoice_date,
    
    -- Customer billing information
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email AS customer_email,
    c.phone AS customer_phone,
    c.address AS billing_address,
    c.city AS billing_city,
    c.postal_code AS billing_postal_code,
    c.country AS billing_country,
    
    -- Shipping information (can be different from billing)
    o.shipping_address,
    o.shipping_city,
    o.shipping_postal_code,
    o.shipping_country,
    
    -- Order information
    o.order_status,
    o.payment_method,
    o.notes AS order_notes,
    
    -- Calculated totals
    SUM(od.quantity * od.unit_price) AS subtotal,
    SUM(od.quantity * od.unit_price * od.discount / 100) AS total_discount,
    SUM(od.quantity * od.unit_price * (1 - od.discount / 100)) AS net_total,
    SUM(od.quantity * od.unit_price * (1 - od.discount / 100)) * 0.23 AS tax_amount,
    SUM(od.quantity * od.unit_price * (1 - od.discount / 100)) * 1.23 AS grand_total,
    
    -- Company information (static for this business)
    'PawPal Pet Supplies' AS company_name,
    'Av. da República 50, 1050-195 Lisboa' AS company_address,
    '+351 21 999 8888' AS company_phone,
    'info@pawpal.pt' AS company_email,
    'www.pawpal.pt' AS company_website,
    'PT507654321' AS company_tax_id
    
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY 
    o.order_id, 
    o.order_date, 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.email, 
    c.phone, 
    c.address, 
    c.city, 
    c.postal_code, 
    c.country,
    o.shipping_address, 
    o.shipping_city, 
    o.shipping_postal_code, 
    o.shipping_country,
    o.order_status, 
    o.payment_method, 
    o.notes;



-- VIEW 2: Invoice Line Details

-- Purpose: Shows individual items for each invoice/order - like the middle part of an invoice
--
-- What it shows per line:
-- - Product name and category
-- - Quantity ordered
-- - Unit price at time of purchase
-- - Discount applied (if any)
-- - Line total (quantity × price × (1 - discount))

-- JOINs used:
-- - orders → order_details (line items)
-- - order_details → products (product info)
-- - products → categories (category name)

CREATE OR REPLACE VIEW vw_invoice_details AS
SELECT 
    o.order_id AS invoice_number,
    od.order_detail_id AS line_number,
    p.product_id,
    p.product_name AS description,
    cat.category_name AS category,
    od.quantity,
    od.unit_price,
    od.discount AS discount_percent,
    (od.quantity * od.unit_price) AS line_subtotal,
    (od.quantity * od.unit_price * od.discount / 100) AS line_discount,
    (od.quantity * od.unit_price * (1 - od.discount / 100)) AS line_total
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
ORDER BY o.order_id, od.order_detail_id;


-- ============================================================
-- SAMPLE QUERIES TO VIEW INVOICES
-- ============================================================

-- View all invoice headers
SELECT * FROM vw_invoice_header;

-- View invoice header for a specific order (e.g., Order #1)
SELECT * FROM vw_invoice_header WHERE invoice_number = 1;

-- View all invoice details
SELECT * FROM vw_invoice_details;

-- View invoice details for a specific order (e.g., Order #1)
SELECT * FROM vw_invoice_details WHERE invoice_number = 1;

-- Complete invoice for Order #1:
-- First, the header:
SELECT 
    invoice_number,
    invoice_date,
    customer_name,
    billing_address,
    billing_city,
    subtotal,
    total_discount,
    net_total,
    tax_amount,
    grand_total
FROM vw_invoice_header 
WHERE invoice_number = 1;

-- Then, the line items:
SELECT 
    line_number,
    description,
    category,
    quantity,
    unit_price,
    discount_percent,
    line_total
FROM vw_invoice_details 
WHERE invoice_number = 1;
