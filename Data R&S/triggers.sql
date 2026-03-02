-- PawPal Pet Supplies - Triggers
--
-- This file contains:
-- 1) Trigger to update stock when a sale is made
-- 2) Trigger to log product updates to the log_table

USE pawpal_db;

DROP TRIGGER IF EXISTS trg_validate_stock_before_sale;
DROP TRIGGER IF EXISTS trg_update_stock_after_sale;
DROP TRIGGER IF EXISTS trg_log_product_update;

DELIMITER //

CREATE TRIGGER trg_validate_stock_before_sale
BEFORE INSERT ON order_details
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    SELECT stock_quantity
      INTO current_stock
      FROM products
     WHERE product_id = NEW.product_id
     FOR UPDATE;

    IF current_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid product_id: product not found.';
    END IF;

    IF NEW.quantity IS NULL OR NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid quantity: must be greater than zero.';
    END IF;

    IF current_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient stock for this product.';
    END IF;
END//

CREATE TRIGGER trg_update_stock_after_sale
AFTER INSERT ON order_details
FOR EACH ROW
BEGIN
    UPDATE products
       SET stock_quantity = stock_quantity - NEW.quantity,
           updated_at = CURRENT_TIMESTAMP
     WHERE product_id = NEW.product_id;
END//

CREATE TRIGGER trg_log_product_update
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF (OLD.stock_quantity <> NEW.stock_quantity)
       OR (OLD.unit_price <> NEW.unit_price)
       OR (OLD.is_active <> NEW.is_active) THEN

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
            OLD.product_id,
            CONCAT('Stock: ', OLD.stock_quantity, ', Price: ', OLD.unit_price, ', Active: ', OLD.is_active),
            CONCAT('Stock: ', NEW.stock_quantity, ', Price: ', NEW.unit_price, ', Active: ', NEW.is_active),
            CONCAT('Product "', OLD.product_name, '" was updated')
        );
    END IF;
END//

DELIMITER ;

-- Trigger demonstration (run in this order)

-- 1) Check stock BEFORE sale
SELECT product_id, product_name, stock_quantity
FROM products
WHERE product_id = 2;

-- 2) Insert order detail using a NEW order
INSERT INTO order_details (order_id, product_id, quantity, unit_price, discount)
VALUES (5, 1, 5, 45.99, 0);

-- 3) Check stock AFTER sale
SELECT product_id, product_name, stock_quantity
FROM products
WHERE product_id = 1;

-- 4) Check log table
SELECT log_id, table_name, action_type, record_id, old_value, new_value, action_description
FROM log_table
ORDER BY log_id DESC
LIMIT 1;
