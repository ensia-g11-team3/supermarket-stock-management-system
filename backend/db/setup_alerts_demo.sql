-- ==========================================
-- COMPLETE ALERTS DEMO SETUP
-- Run this entire script in phpMyAdmin SQL tab
-- ==========================================

-- 1. Create the thresholds table (if it doesn't exist)
CREATE TABLE IF NOT EXISTS thresholds (
    threshold_id INT AUTO_INCREMENT PRIMARY KEY,
    threshold_type VARCHAR(20) NOT NULL,
    entity_id INT NULL,
    category_name VARCHAR(50) NULL,
    threshold_value INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_threshold_type CHECK (
        (threshold_type = 'product' AND entity_id IS NOT NULL AND category_name IS NULL) OR
        (threshold_type = 'category' AND category_name IS NOT NULL AND entity_id IS NULL)
    ),
    CONSTRAINT fk_threshold_product FOREIGN KEY (entity_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 2. Create Categories
INSERT INTO categories (category_name, category_description) VALUES
('Dairy', 'Milk, cheese, etc'),
('Beverages', 'Drinks'),
('Snacks', 'Chips, candy')
ON DUPLICATE KEY UPDATE category_name=category_name;

-- 3. Create Products (some with low stock)
INSERT INTO products (barcode, name, category, qty, product_threshold, unit, buying_price, selling_price, supplier, status, description) VALUES
('TEST001', 'Low Stock Milk', 'Dairy', 5, 10, 'liter', 1.0, 2.0, 'Test Supplier', 'Low stock', 'Testing low stock'),
('TEST002', 'Critical Cheese', 'Dairy', 2, 10, 'piece', 3.0, 5.0, 'Test Supplier', 'Low stock', 'Testing critical stock'),
('TEST003', 'Plenty Water', 'Beverages', 100, 10, 'bottle', 0.5, 1.0, 'Test Supplier', 'In stock', 'Testing normal stock'),
('TEST004', 'Low Chips', 'Snacks', 8, 15, 'bag', 1.0, 2.0, 'Test Supplier', 'Low stock', 'Testing category threshold')
ON DUPLICATE KEY UPDATE qty=VALUES(qty), product_threshold=VALUES(product_threshold), status=VALUES(status);

-- 4. Create Thresholds
-- Category threshold for Snacks (15)
INSERT INTO thresholds (threshold_type, category_name, threshold_value) VALUES
('category', 'Snacks', 15)
ON DUPLICATE KEY UPDATE threshold_value=15;

-- Product threshold for Milk (10)
INSERT INTO thresholds (threshold_type, entity_id, threshold_value) 
SELECT 'product', product_id, 10 FROM products WHERE name = 'Low Stock Milk'
ON DUPLICATE KEY UPDATE threshold_value=10;

-- Product threshold for Cheese (10)
INSERT INTO thresholds (threshold_type, entity_id, threshold_value) 
SELECT 'product', product_id, 10 FROM products WHERE name = 'Critical Cheese'
ON DUPLICATE KEY UPDATE threshold_value=10;

-- 5. Apply Thresholds to Products
-- Apply category thresholds
UPDATE products p
JOIN thresholds t ON p.category = t.category_name AND t.threshold_type = 'category'
SET p.product_threshold = t.threshold_value
WHERE p.product_threshold IS NULL;

-- Apply product thresholds (ensure sync)
UPDATE products p
JOIN thresholds t ON p.product_id = t.entity_id AND t.threshold_type = 'product'
SET p.product_threshold = t.threshold_value;

-- 6. Update Status based on Qty and Threshold
UPDATE products 
SET status = CASE
    WHEN qty = 0 THEN 'Out of stock'
    WHEN qty <= IFNULL(product_threshold, 0) THEN 'Low stock'
    ELSE 'In stock'
END;

-- ==========================================
-- VERIFICATION
-- ==========================================
SELECT name, category, qty, product_threshold, status 
FROM products 
WHERE status = 'Low stock' OR status = 'Out of stock';
