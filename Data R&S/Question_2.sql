
-- BUSINESS QUESTION 2: Monthly Revenue Trend (2023 vs 2024)

-- Question: How is our revenue trending month by month? Are we growing?
--
-- Business Value:
-- This helps the CEO understand:
-- - Business growth trajectory
-- - Seasonal patterns (holiday peaks, summer slowdowns)
-- - Year-over-year performance comparison
-- - Revenue forecasting for future months
--
-- SQL Features Used:
-- - JOIN (2 tables): orders, order_details
-- - GROUP BY: aggregate by year and month
-- - Date functions: YEAR(), MONTH(), MONTHNAME()
-- - SUM() and COUNT(DISTINCT): calculate revenue and order count
-- - ORDER BY: chronological sorting


USE pawpal_db;

SELECT 
    YEAR(o.order_date) AS year,
    MONTH(o.order_date) AS month,
    MONTHNAME(o.order_date) AS month_name,
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    ROUND(SUM(od.quantity * od.unit_price * (1 - od.discount/100)), 2) AS monthly_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date), MONTHNAME(o.order_date)
ORDER BY year, month;

-- EXPECTED RESULTS INTERPRETATION:

-- The query shows revenue progression over time.
-- 
-- Key insights to look for:
-- 1. December typically shows higher revenue (Christmas shopping)
-- 2. Compare 2023 vs 2024 same months for growth rate
-- 3. Identify any unexpected dips or spikes
--
-- Example analysis:
-- If December 2023 = €294.45 and we're in mid-2024,
-- we can project if we'll beat last year's performance.
--
-- Action items for the CEO:
-- 1. Plan inventory for peak months
-- 2. Launch promotions during slow months
-- 3. Set realistic revenue targets based on trends

