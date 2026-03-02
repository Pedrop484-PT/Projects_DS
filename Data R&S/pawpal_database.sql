
-- PawPal Pet Supplies - E-Commerce Database

-- A fictitious online pet supplies store that sells products
-- for dogs, cats, birds, fish, and small animals.
-- 
-- Business Description:
-- PawPal is a small online pet supplies store founded in 2023.
-- Customers can browse products by category, place orders,
-- and rate products after purchase. The store offers various
-- pet food, toys, accessories, and health products.

-- Drop database if exists and create fresh
DROP DATABASE IF EXISTS pawpal_db;
CREATE DATABASE pawpal_db;
USE pawpal_db;

-- TABLE DEFINITIONS (8+ tables, normalized to 3NF)

-- 1. CATEGORIES - Product categories (pet types and product types)
-- Justification: Separate table to avoid redundancy (3NF)
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. SUPPLIERS - Product suppliers/vendors
-- Justification: Normalized to track supplier info separately
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(50),
    country VARCHAR(50) DEFAULT 'Portugal',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. PRODUCTS - All products available in the store
-- Justification: Central entity with foreign keys to categories and suppliers
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    category_id INT NOT NULL,
    supplier_id INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    reorder_level INT DEFAULT 10,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
) ENGINE=InnoDB;

-- 4. CUSTOMERS - Registered customers
-- Justification: Core entity for orders and ratings
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50) DEFAULT 'Portugal',
    registration_date DATE DEFAULT (CURRENT_DATE),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 5. SHIPPING_METHODS - Available shipping options
-- Justification: Normalize shipping options (3NF)
CREATE TABLE shipping_methods (
    shipping_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    base_cost DECIMAL(8,2) NOT NULL,
    estimated_days INT,
    is_active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- 6. ORDERS - Customer orders (header)
-- Justification: Order header separated from details (2NF/3NF)
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
	shipping_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    shipping_address VARCHAR(255),
    shipping_city VARCHAR(50),
    shipping_postal_code VARCHAR(20),
    shipping_country VARCHAR(50) DEFAULT 'Portugal',
    order_status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    payment_method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer', 'MB Way') DEFAULT 'Credit Card',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (shipping_id) REFERENCES shipping_methods(shipping_id)
) ENGINE=InnoDB;

-- 7. ORDER_DETAILS - Individual items in each order
-- Justification: Junction table for many-to-many between orders and products (2NF)
CREATE TABLE order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0.00 CHECK (discount >= 0 AND discount <= 100),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    UNIQUE KEY unique_order_product (order_id, product_id)
) ENGINE=InnoDB;

-- 8. RATINGS - Customer product ratings/reviews
-- Justification: Separate table for product ratings as required by project
CREATE TABLE ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    rating_score INT NOT NULL CHECK (rating_score >= 1 AND rating_score <= 5),
    review_title VARCHAR(100),
    review_text TEXT,
    rating_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    UNIQUE KEY unique_customer_product_rating (customer_id, product_id)
) ENGINE=InnoDB;

-- 9. PAYMENT_TRANSACTIONS - Payment records for orders
-- Justification: Separate financial records from orders (3NF)
CREATE TABLE payment_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('Pending', 'Completed', 'Failed', 'Refunded') DEFAULT 'Pending',
    transaction_reference VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
) ENGINE=InnoDB;

-- 10. LOG_TABLE - System activity log (required for trigger)
-- Justification: Audit trail for database operations
CREATE TABLE log_table (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    record_id INT,
    old_value TEXT,
    new_value TEXT,
    action_description VARCHAR(255),
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_info VARCHAR(100) DEFAULT (CURRENT_USER())
) ENGINE=InnoDB;


-- TRIGGERS

-- TRIGGER 1: Update stock quantity when an order detail is inserted
-- This trigger automatically decreases the product stock when a sale is made
DELIMITER //
CREATE TRIGGER trg_update_stock_after_sale
AFTER INSERT ON order_details
FOR EACH ROW
BEGIN
    UPDATE products 
    SET stock_quantity = stock_quantity - NEW.quantity,
        updated_at = CURRENT_TIMESTAMP
    WHERE product_id = NEW.product_id;
END //
DELIMITER ;

-- TRIGGER 2: Log table insert trigger - logs all product updates
-- This trigger records changes to the products table in the log
DELIMITER //
CREATE TRIGGER trg_log_product_update
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    INSERT INTO log_table (
        table_name,
        action_type,
        record_id,
        old_value,
        new_value,
        action_description
    ) VALUES (
        'products',
        'UPDATE',
        NEW.product_id,
        CONCAT('Stock: ', OLD.stock_quantity, ', Price: ', OLD.unit_price, ', Active: ', OLD.is_active),
        CONCAT('Stock: ', NEW.stock_quantity, ', Price: ', NEW.unit_price, ', Active: ', NEW.is_active),
        CONCAT('Product "', NEW.product_name, '" was updated')
    );
END //
DELIMITER ;

-- INSERT SAMPLE DATA

-- Insert Categories
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

-- Insert Suppliers
INSERT INTO suppliers (supplier_name, contact_name, email, phone, address, city, country) VALUES
('PetFoods Ibérica', 'Carlos Santos', 'carlos@petfoodsiberica.pt', '+351 21 123 4567', 'Rua da Indústria 45', 'Lisboa', 'Portugal'),
('Happy Pets Distribution', 'Maria Costa', 'maria@happypets.pt', '+351 22 234 5678', 'Av. Brasil 123', 'Porto', 'Portugal'),
('EuroPet Supplies', 'Jean Dupont', 'jean@europet.eu', '+33 1 23 45 67 89', 'Rue de Commerce 78', 'Paris', 'France'),
('Pet Wellness Co.', 'Emma Wilson', 'emma@petwellness.co.uk', '+44 20 1234 5678', '15 Pet Lane', 'London', 'United Kingdom'),
('AquaWorld', 'Bruno Silva', 'bruno@aquaworld.pt', '+351 23 345 6789', 'Zona Industrial Lote 12', 'Setúbal', 'Portugal');

-- Insert Products
INSERT INTO products (product_name, description, category_id, supplier_id, unit_price, stock_quantity, reorder_level) VALUES
-- Dog Food
('Premium Dog Kibble 15kg', 'High-quality dry food for adult dogs', 1, 1, 45.99, 100, 15),
('Puppy Growth Formula 5kg', 'Specially formulated for puppies up to 12 months', 1, 1, 28.50, 75, 10),
('Senior Dog Diet 10kg', 'Low-calorie formula for older dogs', 1, 2, 38.99, 50, 10),
-- Cat Food
('Gourmet Cat Pâté 12-pack', 'Wet food variety pack for cats', 2, 1, 18.99, 120, 20),
('Indoor Cat Dry Food 4kg', 'Hairball control formula', 2, 2, 22.50, 80, 15),
('Kitten Starter Kit 2kg', 'Complete nutrition for kittens', 2, 1, 15.99, 60, 10),
-- Dog Toys
('Indestructible Chew Ball', 'Durable rubber ball for aggressive chewers', 3, 3, 12.99, 150, 25),
('Rope Tug Toy', 'Interactive rope toy for fetch and tug', 3, 3, 8.50, 200, 30),
('Squeaky Plush Duck', 'Soft plush toy with squeaker', 3, 2, 9.99, 100, 20),
-- Cat Toys
('Feather Wand Teaser', 'Interactive wand toy with feathers', 4, 3, 6.99, 180, 25),
('Catnip Mouse 3-pack', 'Plush mice filled with organic catnip', 4, 2, 7.50, 150, 20),
('Cat Tower Scratcher', 'Multi-level cat tree with scratching posts', 4, 3, 89.99, 25, 5),
-- Dog Accessories
('Adjustable Nylon Collar M', 'Medium-sized adjustable dog collar', 5, 2, 14.99, 100, 15),
('Retractable Leash 5m', '5-meter retractable dog leash', 5, 3, 24.99, 75, 10),
('Orthopedic Dog Bed Large', 'Memory foam bed for large dogs', 5, 4, 79.99, 30, 5),
-- Cat Accessories
('Self-Cleaning Litter Box', 'Automatic scooping litter box', 6, 4, 149.99, 15, 3),
('Cat Carrier Medium', 'Airline-approved pet carrier', 6, 3, 35.99, 40, 8),
('Cozy Cat Cave Bed', 'Enclosed plush bed for cats', 6, 2, 29.99, 45, 10),
-- Fish Supplies
('20L Starter Aquarium Kit', 'Complete aquarium with filter and light', 7, 5, 89.99, 20, 5),
('Tropical Fish Flakes 100g', 'Daily nutrition for tropical fish', 7, 5, 8.99, 200, 30),
('Aquarium Air Pump', 'Quiet operation air pump', 7, 5, 19.99, 50, 10),
-- Bird Supplies
('Parakeet Seed Mix 1kg', 'Premium seed blend for parakeets', 8, 1, 9.99, 100, 15),
('Bird Cage Deluxe', 'Spacious cage with accessories', 8, 3, 69.99, 15, 3),
('Cuttlebone 2-pack', 'Calcium supplement for birds', 8, 1, 4.99, 150, 20),
-- Small Animal
('Hamster Wheel Silent', 'Noise-free exercise wheel', 9, 3, 12.99, 80, 15),
('Timothy Hay 2kg', 'Premium hay for rabbits and guinea pigs', 9, 1, 11.99, 90, 15),
('Small Animal Bedding 10L', 'Dust-free paper bedding', 9, 2, 14.99, 100, 20),
-- Pet Health
('Dog Multivitamin 60 tablets', 'Daily vitamin supplement for dogs', 10, 4, 24.99, 60, 10),
('Cat Hairball Remedy 100ml', 'Gel formula to prevent hairballs', 10, 4, 12.99, 75, 15),
('Pet Grooming Brush', 'Self-cleaning slicker brush', 10, 2, 16.99, 100, 15);

-- Insert Customers
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

-- Insert Shipping Methods
INSERT INTO shipping_methods (method_name, description, base_cost, estimated_days, is_active) VALUES
('Standard Shipping', 'Regular delivery within Portugal', 4.99, 5, TRUE),
('Express Shipping', 'Fast delivery in 1-2 business days', 9.99, 2, TRUE),
('Free Shipping', 'Free for orders over 50€', 0.00, 7, TRUE),
('International', 'Delivery to EU countries', 14.99, 10, TRUE);

-- Insert Orders (spanning 2023 and 2024 as required)
INSERT INTO orders (customer_id, shipping_id, order_date, shipping_address, shipping_city, shipping_postal_code, order_status, payment_method, notes)
VALUES
-- 2023 Orders
(1, 1, '2023-06-15 10:30:00', 'Rua das Flores 23', 'Lisboa', '1100-123', 'Delivered', 'Credit Card', NULL),
(2, 2, '2023-07-20 14:45:00', 'Av. da Liberdade 456', 'Porto', '4000-321', 'Delivered', 'MB Way', NULL),
(3, 1, '2023-08-05 09:15:00', 'Rua do Comércio 78', 'Faro', '8000-456', 'Delivered', 'PayPal', 'Leave at door'),
(4, 1, '2023-09-12 16:20:00', 'Praça Central 12', 'Coimbra', '3000-789', 'Delivered', 'Credit Card', NULL),
(1, 3, '2023-10-01 11:00:00', 'Rua das Flores 23', 'Lisboa', '1100-123', 'Delivered', 'Debit Card', 'Gift wrap please'),
(5, 2, '2023-10-18 13:30:00', 'Rua Nova 34', 'Braga', '4700-234', 'Delivered', 'Credit Card', NULL),
(6, 1, '2023-11-05 15:45:00', 'Av. dos Aliados 89', 'Setúbal', '2900-567', 'Delivered', 'MB Way', NULL),
(2, 1, '2023-11-22 10:00:00', 'Av. da Liberdade 456', 'Porto', '4000-321', 'Delivered', 'Credit Card', NULL),
(7, 3, '2023-12-03 09:30:00', 'Largo do Carmo 5', 'Évora', '7000-890', 'Delivered', 'PayPal', 'Christmas gift'),
(8, 2, '2023-12-15 14:00:00', 'Rua Augusta 167', 'Lisboa', '1100-234', 'Delivered', 'Credit Card', NULL),

-- 2024 Orders
(3, 1, '2024-01-10 11:30:00', 'Rua do Comércio 78', 'Faro', '8000-456', 'Delivered', 'Credit Card', NULL),
(9, 2, '2024-02-05 16:00:00', 'Av. Brasil 234', 'Porto', '4000-456', 'Delivered', 'MB Way', NULL),
(4, 1, '2024-02-20 10:15:00', 'Praça Central 12', 'Coimbra', '3000-789', 'Delivered', 'Debit Card', NULL),
(10, 1, '2024-03-08 14:30:00', 'Rua do Sol 45', 'Cascais', '2750-123', 'Delivered', 'Credit Card', NULL),
(5, 3, '2024-03-22 09:45:00', 'Rua Nova 34', 'Braga', '4700-234', 'Delivered', 'PayPal', NULL),
(11, 2, '2024-04-05 13:00:00', 'Praça do Rossio 8', 'Lisboa', '1100-345', 'Shipped', 'Credit Card', NULL),
(6, 2, '2024-04-18 15:30:00', 'Av. dos Aliados 89', 'Setúbal', '2900-567', 'Shipped', 'MB Way', 'Call before delivery'),
(12, 1, '2024-05-02 10:45:00', 'Rua Santa Catarina 123', 'Porto', '4000-567', 'Processing', 'Credit Card', NULL),
(1, 1, '2024-05-15 11:20:00', 'Rua das Flores 23', 'Lisboa', '1100-123', 'Processing', 'Debit Card', NULL),
(7, 1, '2024-05-28 14:15:00', 'Largo do Carmo 5', 'Évora', '7000-890', 'Pending', 'Credit Card', NULL),
(8, 2, '2024-06-10 16:40:00', 'Rua Augusta 167', 'Lisboa', '1100-234', 'Pending', 'PayPal', NULL),
(2, 1, '2024-06-25 09:00:00', 'Av. da Liberdade 456', 'Porto', '4000-321', 'Pending', 'Credit Card', NULL);

-- 1 = Standard, 2 = Express, 3 = Free, 4 = International

-- Insert Order Details (this will trigger stock updates)
INSERT INTO order_details (order_id, product_id, quantity, unit_price, discount) VALUES
-- Order 1
(1, 1, 2, 45.99, 0.00),
(1, 7, 1, 12.99, 0.00),
(1, 13, 2, 14.99, 10.00),
-- Order 2
(2, 4, 3, 18.99, 0.00),
(2, 10, 2, 6.99, 0.00),
(2, 18, 1, 29.99, 0.00),
-- Order 3
(3, 19, 1, 89.99, 5.00),
(3, 20, 2, 8.99, 0.00),
(3, 21, 1, 19.99, 0.00),
-- Order 4
(4, 2, 1, 28.50, 0.00),
(4, 8, 2, 8.50, 0.00),
(4, 28, 1, 24.99, 0.00),
-- Order 5
(5, 5, 2, 22.50, 0.00),
(5, 11, 3, 7.50, 0.00),
-- Order 6
(6, 15, 1, 79.99, 10.00),
(6, 9, 2, 9.99, 0.00),
-- Order 7
(7, 22, 2, 9.99, 0.00),
(7, 24, 1, 4.99, 0.00),
(7, 23, 1, 69.99, 0.00),
-- Order 8
(8, 3, 1, 38.99, 0.00),
(8, 14, 1, 24.99, 0.00),
(8, 29, 2, 12.99, 0.00),
-- Order 9
(9, 6, 2, 15.99, 0.00),
(9, 12, 1, 89.99, 15.00),
-- Order 10
(10, 16, 1, 149.99, 0.00),
(10, 17, 1, 35.99, 0.00),
-- Order 11
(11, 1, 1, 45.99, 0.00),
(11, 25, 1, 12.99, 0.00),
(11, 26, 2, 11.99, 0.00),
-- Order 12
(12, 4, 2, 18.99, 5.00),
(12, 30, 1, 16.99, 0.00),
-- Order 13
(13, 27, 3, 14.99, 0.00),
(13, 28, 1, 24.99, 0.00),
-- Order 14
(14, 7, 3, 12.99, 0.00),
(14, 9, 2, 9.99, 0.00),
-- Order 15
(15, 2, 2, 28.50, 0.00),
(15, 8, 1, 8.50, 0.00),
-- Order 16
(16, 19, 1, 89.99, 0.00),
(16, 20, 3, 8.99, 0.00),
-- Order 17
(17, 5, 1, 22.50, 0.00),
(17, 10, 4, 6.99, 0.00),
(17, 11, 2, 7.50, 0.00),
-- Order 18
(18, 15, 1, 79.99, 0.00),
(18, 13, 1, 14.99, 0.00),
-- Order 19
(19, 1, 1, 45.99, 0.00),
(19, 7, 2, 12.99, 0.00),
-- Order 20
(20, 22, 1, 9.99, 0.00),
(20, 26, 1, 11.99, 0.00),
-- Order 21
(21, 3, 2, 38.99, 0.00),
(21, 14, 1, 24.99, 0.00),
-- Order 22
(22, 4, 2, 18.99, 0.00),
(22, 6, 1, 15.99, 0.00);

-- Insert Payment Transactions
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

-- Insert Ratings (customer ratings for products)
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


-- VIEWS FOR INVOICE GENERATION

-- VIEW 1: Invoice Header and Totals
-- Contains order info, customer details, and calculated totals
CREATE VIEW vw_invoice_header AS
SELECT 
    o.order_id AS invoice_number,
    o.order_date AS invoice_date,
    sm.method_name AS shipping_method,
    -- Customer billing information
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email AS customer_email,
    c.phone AS customer_phone,
    c.address AS billing_address,
    c.city AS billing_city,
    c.postal_code AS billing_postal_code,
    c.country AS billing_country,
    -- Shipping information
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
JOIN shipping_methods sm ON o.shipping_id = sm.shipping_id 
JOIN order_details od ON o.order_id = od.order_id
GROUP BY 
    o.order_id, o.order_date, 
    c.customer_id, c.first_name, c.last_name, c.email, c.phone, 
    c.address, c.city, c.postal_code, c.country,
    o.shipping_address, o.shipping_city, o.shipping_postal_code, o.shipping_country,
    o.order_status, o.payment_method, o.notes;

-- VIEW 2: Invoice Line Details
-- Contains individual items for each invoice/order
CREATE VIEW vw_invoice_details AS
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

-- BUSINESS QUESTIONS AND QUERIES (5 queries)


-- QUERY 1: What are the top 5 best-selling products by quantity?
-- Uses: JOIN, GROUP BY, ORDER BY
-- Business Value: Identifies popular products for inventory planning

SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(od.quantity) AS total_quantity_sold,
    SUM(od.quantity * od.unit_price * (1 - od.discount/100)) AS total_revenue
FROM products p
JOIN order_details od ON p.product_id = od.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- QUERY 2: What is the monthly revenue trend comparing 2023 vs 2024?
-- Uses: JOIN, GROUP BY, date functions
-- Business Value: Shows business growth and seasonal patterns

SELECT 
    YEAR(o.order_date) AS year,
    MONTH(o.order_date) AS month,
    MONTHNAME(o.order_date) AS month_name,
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    SUM(od.quantity * od.unit_price * (1 - od.discount/100)) AS monthly_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date), MONTHNAME(o.order_date)
ORDER BY year, month;

-- QUERY 3: Who are the top 5 customers by total spending?
-- Uses: JOIN, GROUP BY, aggregation
-- Business Value: Identifies VIP customers for loyalty programs

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(od.quantity * od.unit_price * (1 - od.discount/100)) AS total_spent,
    ROUND(AVG(od.quantity * od.unit_price * (1 - od.discount/100)), 2) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY total_spent DESC
LIMIT 5;


-- QUERY 4: Which product categories have the highest average rating?
-- Uses: JOIN, GROUP BY, aggregation on ratings
-- Business Value: Shows customer satisfaction by category
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


-- QUERY 5: Which products are running low on stock (below reorder level)?
-- Uses: JOIN, WHERE condition, no GROUP BY (different query type)
-- Business Value: Critical for inventory management and reordering

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


-- DEMONSTRATION OF TRIGGERS

-- To demonstrate Trigger 1 (stock update), check stock before and after insert:
-- SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 1;
-- INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES (22, 1, 5, 45.99);
-- SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 1;

-- To demonstrate Trigger 2 (logging), update a product and check the log:
-- UPDATE products SET unit_price = 49.99 WHERE product_id = 1;
-- SELECT * FROM log_table ORDER BY log_id DESC LIMIT 5;

-- SAMPLE QUERIES TO VERIFY VIEWS (Invoice Generation)

-- View invoice header for order 1
-- SELECT * FROM vw_invoice_header WHERE invoice_number = 1;

-- View invoice details for order 1
-- SELECT * FROM vw_invoice_details WHERE invoice_number = 1;
