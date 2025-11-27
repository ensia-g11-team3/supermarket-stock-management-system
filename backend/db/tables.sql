--Table Creation

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL COMMENT 'Admin, Sales Clerk, Inventory Manager',
    can_view_products BOOLEAN DEFAULT FALSE,
    can_add_product BOOLEAN DEFAULT FALSE,
    can_edit_product BOOLEAN DEFAULT FALSE,
    can_delete_product BOOLEAN DEFAULT FALSE,
    can_view_activity_history BOOLEAN DEFAULT FALSE,
    can_set_alerts BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    barcode VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50) NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    qty INT NOT NULL DEFAULT 0,
    unit VARCHAR(20) NOT NULL DEFAULT 'piece',
    buying_price DECIMAL(10,2) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,
    expiry_date DATE NULL,
    supplier VARCHAR(100) NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'In stock',
    description TEXT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Transactions table
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    worker_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL COMMENT 'Cash / Card',
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transactions_user FOREIGN KEY (worker_id) REFERENCES users(user_id)
);

-- Transaction Items table
CREATE TABLE transaction_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT fk_items_transaction FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);
