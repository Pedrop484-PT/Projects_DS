-- BUSINESS QUESTION 4: Customer Satisfaction by Product Category

-- Question: Which product categories have the highest customer ratings?
--           Where are customers most/least satisfied?
--
-- Business Value:
-- This helps the CEO understand:
-- - Product quality by category
-- - Customer satisfaction levels
-- - Which suppliers provide better products
-- - Where to focus quality improvements
--
-- SQL Features Used:
-- - JOIN (3 tables): categories, products, ratings
-- - GROUP BY: aggregate ratings by category
-- - AVG(): calculate average rating
-- - MIN() and MAX(): show rating range
-- - COUNT(): number of reviews per category
-- - ROUND(): format average to 2 decimal places
-- - HAVING: filter categories with at least 1 review
-- - ORDER BY: sort by highest average rating

USE pawpal_db;

SELECT 
    cat.category_name,
    COUNT(r.rating_id) AS number_of_reviews,
    ROUND(AVG(r.rating_score), 2) AS average_rating,
    MIN(r.rating_score) AS lowest_rating,
    MAX(r.rating_score) AS highest_rating
FROM categories cat
JOIN products p ON cat.category_id = p.category_id
JOIN ratings r ON p.product_id = r.product_id
GROUP BY cat.category_id, cat.category_name
HAVING COUNT(r.rating_id) >= 1
ORDER BY average_rating DESC;


-- EXPECTED RESULTS INTERPRETATION:

-- The query shows customer satisfaction across product categories.
--
-- Rating scale interpretation:
-- - 5.0: Excellent - customers love these products
-- - 4.0-4.9: Good - customers are satisfied
-- - 3.0-3.9: Average - room for improvement
-- - Below 3.0: Poor - investigate quality issues
--
-- Key insights to look for:
-- 1. Categories with 5.0 ratings = promote these more
-- 2. Categories with low ratings = check supplier quality
-- 3. Categories with few reviews = encourage more feedback
-- 4. Large gap between min/max = inconsistent quality
--
-- Action items for the CEO:
-- 1. Investigate products in low-rated categories
-- 2. Consider changing suppliers for poor-quality items
-- 3. Highlight highly-rated categories in marketing
-- 4. Encourage reviews for categories with few ratings

