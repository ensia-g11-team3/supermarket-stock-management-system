-- Sample data for testing the threshold management system

-- First, let's add some sample categories if they don't exist
INSERT INTO categories (category_name, category_description) VALUES
('Dairy', 'Dairy products including milk, cheese, yogurt'),
('Beverages', 'Drinks and beverages'),
('Snacks', 'Snack foods and chips'),
('Bakery', 'Bread, pastries, and baked goods'),
('Pantry', 'Pantry staples and dry goods')
ON DUPLICATE KEY UPDATE category_name=category_name;

-- Add some sample products
INSERT INTO products (barcode, name, category, qty, product_threshold, unit, buying_price, selling_price, supplier, status, description) VALUES
('1001', 'Whole Milk 1L', 'Dairy', 25, NULL, 'liter', 1.50, 2.50, 'Dairy Farms Co.', 'In stock', 'Fresh whole milk'),
('1002', 'Cheddar Cheese 500g', 'Dairy', 8, NULL, 'piece', 4.00, 6.50, 'Dairy Farms Co.', 'In stock', 'Aged cheddar cheese'),
('1003', 'Greek Yogurt 200g', 'Dairy', 15, NULL, 'piece', 1.20, 2.00, 'Dairy Farms Co.', 'In stock', 'Natural Greek yogurt'),
('2001', 'Orange Juice 1L', 'Beverages', 30, NULL, 'liter', 2.00, 3.50, 'Fresh Drinks Ltd.', 'In stock', 'Fresh squeezed orange juice'),
('2002', 'Cola 2L', 'Beverages', 45, NULL, 'bottle', 1.50, 2.50, 'Beverage Distributors', 'In stock', 'Carbonated soft drink'),
('2003', 'Mineral Water 500ml', 'Beverages', 100, NULL, 'bottle', 0.50, 1.00, 'Water Source Inc.', 'In stock', 'Natural mineral water'),
('3001', 'Potato Chips 150g', 'Snacks', 40, NULL, 'bag', 1.00, 1.80, 'Snack Factory', 'In stock', 'Salted potato chips'),
('3002', 'Chocolate Bar 100g', 'Snacks', 60, NULL, 'piece', 0.80, 1.50, 'Sweet Treats Co.', 'In stock', 'Milk chocolate bar'),
('4001', 'White Bread 500g', 'Bakery', 20, NULL, 'loaf', 1.20, 2.00, 'Local Bakery', 'In stock', 'Fresh white bread'),
('4002', 'Croissant', 'Bakery', 12, NULL, 'piece', 0.60, 1.20, 'Local Bakery', 'In stock', 'Butter croissant'),
('5001', 'Rice 1kg', 'Pantry', 50, NULL, 'kg', 2.00, 3.50, 'Grain Suppliers', 'In stock', 'Long grain white rice'),
('5002', 'Pasta 500g', 'Pantry', 35, NULL, 'package', 1.00, 1.80, 'Italian Foods', 'In stock', 'Spaghetti pasta')
ON DUPLICATE KEY UPDATE name=name;

-- Add some sample thresholds
-- Category thresholds
INSERT INTO thresholds (threshold_type, category_name, threshold_value) VALUES
('category', 'Dairy', 10),
('category', 'Beverages', 20)
ON DUPLICATE KEY UPDATE threshold_value=threshold_value;

-- Product-specific thresholds (these override category thresholds)
INSERT INTO thresholds (threshold_type, entity_id, threshold_value)
SELECT 'product', product_id, 5
FROM products
WHERE name = 'Cheddar Cheese 500g'
ON DUPLICATE KEY UPDATE threshold_value=threshold_value;

INSERT INTO thresholds (threshold_type, entity_id, threshold_value)
SELECT 'product', product_id, 15
FROM products
WHERE name = 'Potato Chips 150g'
ON DUPLICATE KEY UPDATE threshold_value=threshold_value;

-- Apply category thresholds to products
UPDATE products 
SET product_threshold = 10 
WHERE category = 'Dairy' AND product_threshold IS NULL;

UPDATE products 
SET product_threshold = 20 
WHERE category = 'Beverages' AND product_threshold IS NULL;

-- Note: Products with specific thresholds in the thresholds table will override these values
UPDATE products p
INNER JOIN thresholds t ON p.product_id = t.entity_id AND t.threshold_type = 'product'
SET p.product_threshold = t.threshold_value;
