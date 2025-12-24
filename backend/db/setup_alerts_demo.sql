-- ==========================================
-- COMPLETE ALERTS DEMO SETUP
-- Run this entire script in phpMyAdmin SQL tab
-- ==========================================

-- 1. Create Categories
INSERT INTO categories (category_name, category_description) VALUES
('Dairy', 'Milk, cheese, etc'),
('Beverages', 'Drinks'),
('Snacks', 'Chips, candy')
ON DUPLICATE KEY UPDATE category_name=category_name;

-- 2. Create Products (some with low stock)
INSERT INTO products (barcode, name, category, qty, unit, buying_price, selling_price, supplier, status, description) VALUES
('TEST001', 'Low Stock Milk', 'Dairy', 5, 'liter', 1.0, 2.0, 'Test Supplier', 'Low stock', 'Testing low stock'),
('TEST002', 'Critical Cheese', 'Dairy', 2, 'piece', 3.0, 5.0, 'Test Supplier', 'Low stock', 'Testing critical stock'),
('TEST003', 'Plenty Water', 'Beverages', 100, 'bottle', 0.5, 1.0, 'Test Supplier', 'In stock', 'Testing normal stock'),
('TEST004', 'Low Chips', 'Snacks', 8, 'bag', 1.0, 2.0, 'Test Supplier', 'Low stock', 'Testing low stock')
ON DUPLICATE KEY UPDATE qty=VALUES(qty), status=VALUES(status);

-- 3. Update Status based on Qty
UPDATE products 
SET status = CASE
    WHEN qty = 0 THEN 'Out of stock'
    WHEN qty <= 10 THEN 'Low stock'
    ELSE 'In stock'
END;

-- ==========================================
-- VERIFICATION
-- ==========================================
SELECT name, category, qty, status 
FROM products 
WHERE status = 'Low stock' OR status = 'Out of stock';

