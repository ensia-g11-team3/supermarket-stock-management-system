-- Dummy threshold data for testing
-- This creates a variety of thresholds to test the threshold management system

-- Clear existing thresholds (optional - comment out if you want to keep existing data)
-- DELETE FROM thresholds;

-- Category-level thresholds
INSERT INTO thresholds (threshold_type, category_name, threshold_value) VALUES
('category', 'Dairy', 10),
('category', 'Beverages', 25),
('category', 'Snacks', 15),
('category', 'Bakery', 8)
ON DUPLICATE KEY UPDATE threshold_value=VALUES(threshold_value);

-- Product-level thresholds (these will override category thresholds)
-- Get product IDs and insert thresholds
INSERT INTO thresholds (threshold_type, entity_id, threshold_value)
SELECT 'product', product_id, 5
FROM products WHERE name = 'Whole Milk 1L'
ON DUPLICATE KEY UPDATE threshold_value=VALUES(threshold_value);

INSERT INTO thresholds (threshold_type, entity_id, threshold_value)
SELECT 'product', product_id, 3
FROM products WHERE name = 'Cheddar Cheese 500g'
ON DUPLICATE KEY UPDATE threshold_value=VALUES(threshold_value);

INSERT INTO thresholds (threshold_type, entity_id, threshold_value)
SELECT 'product', product_id, 12
FROM products WHERE name = 'Greek Yogurt 200g'
ON DUPLICATE KEY UPDATE threshold_value=VALUES(threshold_value);

INSERT INTO thresholds (threshold_type, entity_id, threshold_value)
SELECT 'product', product_id, 30
FROM products WHERE name = 'Orange Juice 1L'
ON DUPLICATE KEY UPDATE threshold_value=VALUES(threshold_value);

INSERT INTO thresholds (threshold_type, entity_id, threshold_value)
SELECT 'product', product_id, 20
FROM products WHERE name = 'Potato Chips 150g'
ON DUPLICATE KEY UPDATE threshold_value=VALUES(threshold_value);

INSERT INTO thresholds (threshold_type, entity_id, threshold_value)
SELECT 'product', product_id, 6
FROM products WHERE name = 'White Bread 500g'
ON DUPLICATE KEY UPDATE threshold_value=VALUES(threshold_value);

-- Apply category thresholds to products that don't have specific thresholds
UPDATE products p
LEFT JOIN thresholds t ON p.product_id = t.entity_id AND t.threshold_type = 'product'
INNER JOIN thresholds ct ON p.category = ct.category_name AND ct.threshold_type = 'category'
SET p.product_threshold = ct.threshold_value
WHERE t.threshold_id IS NULL;

-- Apply product-specific thresholds
UPDATE products p
INNER JOIN thresholds t ON p.product_id = t.entity_id AND t.threshold_type = 'product'
SET p.product_threshold = t.threshold_value;

-- Update some products to have low stock for testing alerts
UPDATE products SET qty = 4 WHERE name = 'Cheddar Cheese 500g';
UPDATE products SET qty = 7 WHERE name = 'Greek Yogurt 200g';
UPDATE products SET qty = 18 WHERE name = 'Potato Chips 150g';
UPDATE products SET qty = 5 WHERE name = 'White Bread 500g';
UPDATE products SET qty = 22 WHERE name = 'Orange Juice 1L';

-- Update product status based on qty and threshold
UPDATE products 
SET status = CASE
    WHEN qty = 0 THEN 'Out of stock'
    WHEN qty <= product_threshold THEN 'Low stock'
    ELSE 'In stock'
END;

-- View results
SELECT 
    p.name,
    p.category,
    p.qty,
    p.product_threshold,
    p.status,
    CASE 
        WHEN t.threshold_type = 'product' THEN 'Product-specific'
        ELSE 'Category-level'
    END as threshold_source
FROM products p
LEFT JOIN thresholds t ON p.product_id = t.entity_id AND t.threshold_type = 'product'
ORDER BY p.category, p.name;
