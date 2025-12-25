-- Create a default sales clerk user for POS transactions
-- Run this script to fix the foreign key constraint error

-- First, check if user with ID 1 exists
SELECT * FROM users WHERE user_id = 1;

-- If no user exists, insert a default sales clerk
INSERT INTO users (
    user_id,
    username,
    full_name,
    phone_number,
    email,
    password_hash,
    is_active,
    role,
    can_view_products,
    can_add_product,
    can_edit_product,
    can_delete_product,
    can_view_activity_history,
    can_set_alerts
) VALUES (
    1,
    'sales_clerk',
    'Default Sales Clerk',
    '+1234567890',
    'sales@store.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYPdx7wzdlO', -- password: "password123"
    TRUE,
    'Sales Clerk',
    TRUE,
    FALSE,
    FALSE,
    FALSE,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE user_id = user_id; -- Do nothing if user already exists

-- Verify the user was created
SELECT user_id, username, full_name, role FROM users WHERE user_id = 1;
