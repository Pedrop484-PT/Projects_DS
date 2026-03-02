
-- PawPal Pet Supplies - Loading Data

-- This file contains all INSERT statements to populate the database
-- with sample data spanning 2023-2024 (two consecutive years)


USE pawpal_db;


-- CATEGORIES (10 categories for different pet types and products)

INSERT INTO categories (category_name, description) VALUES
('Dog Food', 'Dry and wet food for dogs of all sizes'),
('Cat Food', 'Premium food for cats'),
('Dog Toys', 'Interactive and chew toys for dogs'),
('Cat Toys', 'Toys and scratchers for cats'),
('Dog Accessories', 'Collars, leashes, and beds for dogs'),
('Cat Accessories', 'Litter boxes, carriers, and beds for cats'),
('Fish Supplies', 'Aquariums, food, and accessories for fish'),
('Bird Supplies', 'Cages, food, and toys for birds'),
('Small Animal', 'Supplies for hamsters, rabbits, and guinea pigs'),
('Pet Health', 'Vitamins, supplements, and grooming products');

SELECT * FROM categories LIMIT 5;



-- SUPPLIERS (5 Portuguese and European suppliers)

INSERT INTO suppliers (supplier_name, contact_name, email, phone, address, city, country) VALUES
('PetFoods Ibérica', 'Carlos Santos', 'carlos@petfoodsiberica.pt', '+351 21 123 4567', 'Rua da Indústria 45', 'Lisboa', 'Portugal'),
('Happy Pets Distribution', 'Maria Costa', 'maria@happypets.pt', '+351 22 234 5678', 'Av. Brasil 123', 'Porto', 'Portugal'),
('EuroPet Supplies', 'Jean Dupont', 'jean@europet.eu', '+33 1 23 45 67 89', 'Rue de Commerce 78', 'Paris', 'France'),
('Pet Wellness Co.', 'Emma Wilson', 'emma@petwellness.co.uk', '+44 20 1234 5678', '15 Pet Lane', 'London', 'United Kingdom'),
('AquaWorld', 'Bruno Silva', 'bruno@aquaworld.pt', '+351 23 345 6789', 'Zona Industrial Lote 12', 'Setúbal', 'Portugal');

SELECT * FROM suppliers LIMIT 5;



-- PRODUCTS (30 products across all categories)

INSERT INTO products (product_name, description, category_id, supplier_id, unit_price, stock_quantity, reorder_level) VALUES
-- Dog Food (category_id = 1)
('Premium Dog Kibble 15kg', 'High-quality dry food for adult dogs', 1, 1, 45.99, 100, 15),
('Puppy Growth Formula 5kg', 'Specially formulated for puppies up to 12 months', 1, 1, 28.50, 75, 10),
('Senior Dog Diet 10kg', 'Low-calorie formula for older dogs', 1, 2, 38.99, 50, 10),
-- Cat Food (category_id = 2)
('Gourmet Cat Pâté 12-pack', 'Wet food variety pack for cats', 2, 1, 18.99, 120, 20),
('Indoor Cat Dry Food 4kg', 'Hairball control formula', 2, 2, 22.50, 80, 15),
('Kitten Starter Kit 2kg', 'Complete nutrition for kittens', 2, 1, 15.99, 60, 10),
-- Dog Toys (category_id = 3)
('Indestructible Chew Ball', 'Durable rubber ball for aggressive chewers', 3, 3, 12.99, 150, 25),
('Rope Tug Toy', 'Interactive rope toy for fetch and tug', 3, 3, 8.50, 200, 30),
('Squeaky Plush Duck', 'Soft plush toy with squeaker', 3, 2, 9.99, 100, 20),
-- Cat Toys (category_id = 4)
('Feather Wand Teaser', 'Interactive wand toy with feathers', 4, 3, 6.99, 180, 25),
('Catnip Mouse 3-pack', 'Plush mice filled with organic catnip', 4, 2, 7.50, 150, 20),
('Cat Tower Scratcher', 'Multi-level cat tree with scratching posts', 4, 3, 89.99, 25, 5),
-- Dog Accessories (category_id = 5)
('Adjustable Nylon Collar M', 'Medium-sized adjustable dog collar', 5, 2, 14.99, 100, 15),
('Retractable Leash 5m', '5-meter retractable dog leash', 5, 3, 24.99, 75, 10),
('Orthopedic Dog Bed Large', 'Memory foam bed for large dogs', 5, 4, 79.99, 30, 5),
-- Cat Accessories (category_id = 6)
('Self-Cleaning Litter Box', 'Automatic scooping litter box', 6, 4, 149.99, 15, 3),
('Cat Carrier Medium', 'Airline-approved pet carrier', 6, 3, 35.99, 40, 8),
('Cozy Cat Cave Bed', 'Enclosed plush bed for cats', 6, 2, 29.99, 45, 10),
-- Fish Supplies (category_id = 7)
('20L Starter Aquarium Kit', 'Complete aquarium with filter and light', 7, 5, 89.99, 20, 5),
('Tropical Fish Flakes 100g', 'Daily nutrition for tropical fish', 7, 5, 8.99, 200, 30),
('Aquarium Air Pump', 'Quiet operation air pump', 7, 5, 19.99, 50, 10),
-- Bird Supplies (category_id = 8)
('Parakeet Seed Mix 1kg', 'Premium seed blend for parakeets', 8, 1, 9.99, 100, 15),
('Bird Cage Deluxe', 'Spacious cage with accessories', 8, 3, 69.99, 15, 3),
('Cuttlebone 2-pack', 'Calcium supplement for birds', 8, 1, 4.99, 150, 20),
-- Small Animal (category_id = 9)
('Hamster Wheel Silent', 'Noise-free exercise wheel', 9, 3, 12.99, 80, 15),
('Timothy Hay 2kg', 'Premium hay for rabbits and guinea pigs', 9, 1, 11.99, 90, 15),
('Small Animal Bedding 10L', 'Dust-free paper bedding', 9, 2, 14.99, 100, 20),
-- Pet Health (category_id = 10)
('Dog Multivitamin 60 tablets', 'Daily vitamin supplement for dogs', 10, 4, 24.99, 60, 10),
('Cat Hairball Remedy 100ml', 'Gel formula to prevent hairballs', 10, 4, 12.99, 75, 15),
('Pet Grooming Brush', 'Self-cleaning slicker brush', 10, 2, 16.99, 100, 15);

SELECT * FROM products LIMIT 5;



-- CUSTOMERS (12 Portuguese customers)

INSERT INTO customers (first_name, last_name, email, phone, address, city, postal_code, country, registration_date) VALUES
('João', 'Silva', 'joao.silva@email.pt', '+351 91 234 5678', 'Rua das Flores 23', 'Lisboa', '1100-123', 'Portugal', '2023-03-15'),
('Ana', 'Santos', 'ana.santos@email.pt', '+351 92 345 6789', 'Av. da Liberdade 456', 'Porto', '4000-321', 'Portugal', '2023-04-22'),
('Pedro', 'Costa', 'pedro.costa@email.pt', '+351 93 456 7890', 'Rua do Comércio 78', 'Faro', '8000-456', 'Portugal', '2023-05-10'),
('Maria', 'Ferreira', 'maria.ferreira@email.pt', '+351 94 567 8901', 'Praça Central 12', 'Coimbra', '3000-789', 'Portugal', '2023-06-18'),
('Carlos', 'Oliveira', 'carlos.oliveira@email.pt', '+351 95 678 9012', 'Rua Nova 34', 'Braga', '4700-234', 'Portugal', '2023-07-25'),
('Sofia', 'Rodrigues', 'sofia.rodrigues@email.pt', '+351 96 789 0123', 'Av. dos Aliados 89', 'Setúbal', '2900-567', 'Portugal', '2023-08-30'),
('Miguel', 'Martins', 'miguel.martins@email.pt', '+351 97 890 1234', 'Largo do Carmo 5', 'Évora', '7000-890', 'Portugal', '2023-09-12'),
('Inês', 'Pereira', 'ines.pereira@email.pt', '+351 98 901 2345', 'Rua Augusta 167', 'Lisboa', '1100-234', 'Portugal', '2023-10-05'),
('Ricardo', 'Almeida', 'ricardo.almeida@email.pt', '+351 91 012 3456', 'Av. Brasil 234', 'Porto', '4000-456', 'Portugal', '2024-01-15'),
('Beatriz', 'Sousa', 'beatriz.sousa@email.pt', '+351 92 123 4567', 'Rua do Sol 45', 'Cascais', '2750-123', 'Portugal', '2024-02-20'),
('André', 'Lopes', 'andre.lopes@email.pt', '+351 93 234 5678', 'Praça do Rossio 8', 'Lisboa', '1100-345', 'Portugal', '2024-03-08'),
('Catarina', 'Nunes', 'catarina.nunes@email.pt', '+351 94 345 6789', 'Rua Santa Catarina 123', 'Porto', '4000-567', 'Portugal', '2024-04-12');

SELECT * FROM customers LIMIT 5;



-- SHIPPING_METHODS (4 delivery options)

INSERT INTO shipping_methods (method_name, description, base_cost, estimated_days, is_active) VALUES
('Standard Shipping', 'Regular delivery within Portugal', 4.99, 5, TRUE),
('Express Shipping', 'Fast delivery in 1-2 business days', 9.99, 2, TRUE),
('Free Shipping', 'Free for orders over 50€', 0.00, 7, TRUE),
('International', 'Delivery to EU countries', 14.99, 10, TRUE);

SELECT * FROM shipping_methods LIMIT 5;


-- ORDERS (22 orders spanning 2023 and 2024 - TWO CONSECUTIVE YEARS)

INSERT INTO orders (customer_id, order_date, shipping_address, shipping_city, shipping_postal_code, order_status, payment_method, notes) VALUES
-- 2023 Orders (10 orders)
(1, '2023-06-15 10:30:00', 'Rua das Flores 23', 'Lisboa', '1100-123', 'Delivered', 'Credit Card', NULL),
(2, '2023-07-20 14:45:00', 'Av. da Liberdade 456', 'Porto', '4000-321', 'Delivered', 'MB Way', NULL),
(3, '2023-08-05 09:15:00', 'Rua do Comércio 78', 'Faro', '8000-456', 'Delivered', 'PayPal', 'Leave at door'),
(4, '2023-09-12 16:20:00', 'Praça Central 12', 'Coimbra', '3000-789', 'Delivered', 'Credit Card', NULL),
(1, '2023-10-01 11:00:00', 'Rua das Flores 23', 'Lisboa', '1100-123', 'Delivered', 'Debit Card', 'Gift wrap please'),
(5, '2023-10-18 13:30:00', 'Rua Nova 34', 'Braga', '4700-234', 'Delivered', 'Credit Card', NULL),
(6, '2023-11-05 15:45:00', 'Av. dos Aliados 89', 'Setúbal', '2900-567', 'Delivered', 'MB Way', NULL),
(2, '2023-11-22 10:00:00', 'Av. da Liberdade 456', 'Porto', '4000-321', 'Delivered', 'Credit Card', NULL),
(7, '2023-12-03 09:30:00', 'Largo do Carmo 5', 'Évora', '7000-890', 'Delivered', 'PayPal', 'Christmas gift'),
(8, '2023-12-15 14:00:00', 'Rua Augusta 167', 'Lisboa', '1100-234', 'Delivered', 'Credit Card', NULL),
-- 2024 Orders (12 orders)
(3, '2024-01-10 11:30:00', 'Rua do Comércio 78', 'Faro', '8000-456', 'Delivered', 'Credit Card', NULL),
(9, '2024-02-05 16:00:00', 'Av. Brasil 234', 'Porto', '4000-456', 'Delivered', 'MB Way', NULL),
(4, '2024-02-20 10:15:00', 'Praça Central 12', 'Coimbra', '3000-789', 'Delivered', 'Debit Card', NULL),
(10, '2024-03-08 14:30:00', 'Rua do Sol 45', 'Cascais', '2750-123', 'Delivered', 'Credit Card', NULL),
(5, '2024-03-22 09:45:00', 'Rua Nova 34', 'Braga', '4700-234', 'Delivered', 'PayPal', NULL),
(11, '2024-04-05 13:00:00', 'Praça do Rossio 8', 'Lisboa', '1100-345', 'Shipped', 'Credit Card', NULL),
(6, '2024-04-18 15:30:00', 'Av. dos Aliados 89', 'Setúbal', '2900-567', 'Shipped', 'MB Way', 'Call before delivery'),
(12, '2024-05-02 10:45:00', 'Rua Santa Catarina 123', 'Porto', '4000-567', 'Processing', 'Credit Card', NULL),
(1, '2024-05-15 11:20:00', 'Rua das Flores 23', 'Lisboa', '1100-123', 'Processing', 'Debit Card', NULL),
(7, '2024-05-28 14:15:00', 'Largo do Carmo 5', 'Évora', '7000-890', 'Pending', 'Credit Card', NULL),
(8, '2024-06-10 16:40:00', 'Rua Augusta 167', 'Lisboa', '1100-234', 'Pending', 'PayPal', NULL),
(2, '2024-06-25 09:00:00', 'Av. da Liberdade 456', 'Porto', '4000-321', 'Pending', 'Credit Card', NULL);

SELECT * FROM orders LIMIT 5;



-- ORDER_DETAILS (52 line items - this will trigger stock updates!)

INSERT INTO order_details (order_id, product_id, quantity, unit_price, discount) VALUES
-- Order 1 (3 items)
(1, 1, 2, 45.99, 0.00),
(1, 7, 1, 12.99, 0.00),
(1, 13, 2, 14.99, 10.00),
-- Order 2 (3 items)
(2, 4, 3, 18.99, 0.00),
(2, 10, 2, 6.99, 0.00),
(2, 18, 1, 29.99, 0.00),
-- Order 3 (3 items)
(3, 19, 1, 89.99, 5.00),
(3, 20, 2, 8.99, 0.00),
(3, 21, 1, 19.99, 0.00),
-- Order 4 (3 items)
(4, 2, 1, 28.50, 0.00),
(4, 8, 2, 8.50, 0.00),
(4, 28, 1, 24.99, 0.00),
-- Order 5 (2 items)
(5, 5, 2, 22.50, 0.00),
(5, 11, 3, 7.50, 0.00),
-- Order 6 (2 items)
(6, 15, 1, 79.99, 10.00),
(6, 9, 2, 9.99, 0.00),
-- Order 7 (3 items)
(7, 22, 2, 9.99, 0.00),
(7, 24, 1, 4.99, 0.00),
(7, 23, 1, 69.99, 0.00),
-- Order 8 (3 items)
(8, 3, 1, 38.99, 0.00),
(8, 14, 1, 24.99, 0.00),
(8, 29, 2, 12.99, 0.00),
-- Order 9 (2 items)
(9, 6, 2, 15.99, 0.00),
(9, 12, 1, 89.99, 15.00),
-- Order 10 (2 items)
(10, 16, 1, 149.99, 0.00),
(10, 17, 1, 35.99, 0.00),
-- Order 11 (3 items)
(11, 1, 1, 45.99, 0.00),
(11, 25, 1, 12.99, 0.00),
(11, 26, 2, 11.99, 0.00),
-- Order 12 (2 items)
(12, 4, 2, 18.99, 5.00),
(12, 30, 1, 16.99, 0.00),
-- Order 13 (2 items)
(13, 27, 3, 14.99, 0.00),
(13, 28, 1, 24.99, 0.00),
-- Order 14 (2 items)
(14, 7, 3, 12.99, 0.00),
(14, 9, 2, 9.99, 0.00),
-- Order 15 (2 items)
(15, 2, 2, 28.50, 0.00),
(15, 8, 1, 8.50, 0.00),
-- Order 16 (2 items)
(16, 19, 1, 89.99, 0.00),
(16, 20, 3, 8.99, 0.00),
-- Order 17 (3 items)
(17, 5, 1, 22.50, 0.00),
(17, 10, 4, 6.99, 0.00),
(17, 11, 2, 7.50, 0.00),
-- Order 18 (2 items)
(18, 15, 1, 79.99, 0.00),
(18, 13, 1, 14.99, 0.00),
-- Order 19 (2 items)
(19, 1, 1, 45.99, 0.00),
(19, 7, 2, 12.99, 0.00),
-- Order 20 (2 items)
(20, 22, 1, 9.99, 0.00),
(20, 26, 1, 11.99, 0.00),
-- Order 21 (2 items)
(21, 3, 2, 38.99, 0.00),
(21, 14, 1, 24.99, 0.00),
-- Order 22 (2 items)
(22, 4, 2, 18.99, 0.00),
(22, 6, 1, 15.99, 0.00);

SELECT * FROM order_details LIMIT 5;



-- PAYMENT_TRANSACTIONS (22 transactions, one per order)

INSERT INTO payment_transactions (order_id, transaction_date, amount, payment_status, transaction_reference) VALUES
(1, '2023-06-15 10:31:00', 131.94, 'Completed', 'TXN-2023-0001'),
(2, '2023-07-20 14:46:00', 100.93, 'Completed', 'TXN-2023-0002'),
(3, '2023-08-05 09:16:00', 123.46, 'Completed', 'TXN-2023-0003'),
(4, '2023-09-12 16:21:00', 70.49, 'Completed', 'TXN-2023-0004'),
(5, '2023-10-01 11:01:00', 67.50, 'Completed', 'TXN-2023-0005'),
(6, '2023-10-18 13:31:00', 91.97, 'Completed', 'TXN-2023-0006'),
(7, '2023-11-05 15:46:00', 94.96, 'Completed', 'TXN-2023-0007'),
(8, '2023-11-22 10:01:00', 89.96, 'Completed', 'TXN-2023-0008'),
(9, '2023-12-03 09:31:00', 108.46, 'Completed', 'TXN-2023-0009'),
(10, '2023-12-15 14:01:00', 185.98, 'Completed', 'TXN-2023-0010'),
(11, '2024-01-10 11:31:00', 71.96, 'Completed', 'TXN-2024-0001'),
(12, '2024-02-05 16:01:00', 54.96, 'Completed', 'TXN-2024-0002'),
(13, '2024-02-20 10:16:00', 69.96, 'Completed', 'TXN-2024-0003'),
(14, '2024-03-08 14:31:00', 58.95, 'Completed', 'TXN-2024-0004'),
(15, '2024-03-22 09:46:00', 65.50, 'Completed', 'TXN-2024-0005'),
(16, '2024-04-05 13:01:00', 116.96, 'Completed', 'TXN-2024-0006'),
(17, '2024-04-18 15:31:00', 65.46, 'Completed', 'TXN-2024-0007'),
(18, '2024-05-02 10:46:00', 94.98, 'Pending', 'TXN-2024-0008'),
(19, '2024-05-15 11:21:00', 71.97, 'Pending', 'TXN-2024-0009'),
(20, '2024-05-28 14:16:00', 21.98, 'Pending', 'TXN-2024-0010'),
(21, '2024-06-10 16:41:00', 102.97, 'Pending', 'TXN-2024-0011'),
(22, '2024-06-25 09:01:00', 53.97, 'Pending', 'TXN-2024-0012');

SELECT * FROM payment_transactions LIMIT 5;


-- RATINGS (20 customer reviews for products)

INSERT INTO ratings (customer_id, product_id, rating_score, review_title, review_text, rating_date, is_verified_purchase) VALUES
(1, 1, 5, 'Excellent quality!', 'My dog loves this food. Great ingredients and he eats it all.', '2023-06-20 10:00:00', TRUE),
(1, 7, 4, 'Very durable', 'The ball has lasted months with my aggressive chewer.', '2023-06-22 14:30:00', TRUE),
(2, 4, 5, 'Cats love it', 'All three of my cats go crazy for this pâté. Highly recommend!', '2023-07-25 09:15:00', TRUE),
(2, 10, 4, 'Fun toy', 'Keeps my cat entertained for hours.', '2023-07-26 11:00:00', TRUE),
(3, 19, 5, 'Perfect starter kit', 'Everything you need to start your first aquarium.', '2023-08-12 16:20:00', TRUE),
(3, 20, 4, 'Good food', 'Fish seem healthy and active since switching to this.', '2023-08-15 10:45:00', TRUE),
(4, 2, 5, 'Puppy approved', 'Our new puppy is thriving on this formula.', '2023-09-18 13:30:00', TRUE),
(4, 28, 4, 'Good supplement', 'Easy to give and my dog seems more energetic.', '2023-09-20 15:00:00', TRUE),
(5, 15, 5, 'Worth the price', 'Best dog bed we have ever bought. Memory foam is excellent.', '2023-10-25 11:20:00', TRUE),
(6, 22, 4, 'Birds love it', 'Quality seeds, my parakeets eat it all.', '2023-11-10 14:00:00', TRUE),
(7, 23, 5, 'Great cage', 'Spacious and well-made. Easy to clean.', '2023-12-10 10:30:00', TRUE),
(8, 16, 5, 'Game changer!', 'No more scooping! This litter box is amazing.', '2023-12-20 09:45:00', TRUE),
(9, 4, 4, 'Good variety', 'Cats enjoy the different flavors.', '2024-02-10 16:15:00', TRUE),
(10, 17, 5, 'Perfect for travel', 'Used it for vet visits. Very sturdy and comfortable for my cat.', '2024-03-15 11:00:00', TRUE),
(11, 1, 4, 'Quality food', 'Good ingredients but a bit pricey.', '2024-04-10 14:30:00', TRUE),
(1, 5, 4, 'Good for indoor cats', 'Helps with hairballs. My cat likes the taste.', '2023-10-08 10:00:00', TRUE),
(3, 21, 3, 'Works okay', 'Does the job but a bit noisy.', '2024-01-15 15:30:00', TRUE),
(6, 24, 5, 'Essential item', 'Great for calcium, birds need this.', '2023-11-12 09:00:00', TRUE),
(8, 17, 4, 'Good carrier', 'Well made and my cat fits comfortably.', '2023-12-22 11:45:00', TRUE),
(12, 30, 5, 'Best grooming brush', 'Self-cleaning feature is so convenient. My dog loves being brushed now.', '2024-05-08 10:00:00', TRUE);

SELECT * FROM ratings LIMIT 5;



-- VERIFICATION QUERIES


-- Check record counts
SELECT 'categories' AS table_name, COUNT(*) AS row_count FROM categories
UNION ALL SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_details', COUNT(*) FROM order_details
UNION ALL SELECT 'ratings', COUNT(*) FROM ratings
UNION ALL SELECT 'payment_transactions', COUNT(*) FROM payment_transactions
UNION ALL SELECT 'shipping_methods', COUNT(*) FROM shipping_methods;

-- Check orders by year (should have both 2023 and 2024)
SELECT YEAR(order_date) AS year, COUNT(*) AS order_count 
FROM orders 
GROUP BY YEAR(order_date);
