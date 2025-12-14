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
    product_threshold INT, -- added in second sprint
    unit VARCHAR(20) NOT NULL DEFAULT 'piece',
    buying_price DECIMAL(10,2) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,
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
    transaction_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_items_transaction FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Categories table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    category_description TEXT,
);

-- Supplier
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(50) NOT NULL,
    supplier_description TEXT
);

-- Product batch table
CREATE TABLE product_batches (
    batch_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL, --FK
    quantity INT NOT NULL,
    -- both dates can be NULL 
    manifacture_date DATE,
    expiry_date DATE,
    supplier_id INT,

    CONSTRAINT fk_batch_product FOREIGN KEY (product_id) REFERENCES products(product_id)
    CONSTRAINT fk_batch_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- alerts table
CREATE TABLE low_stock_alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL, 
    -- threshold and current qty not here but you get it from products table by product_id
    is_active BOOLEAN DEFAULT TRUE, -- whether alert is active or resolved
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- the time when qty fell below threshold qty <= threshold
    CONSTRAINT fk_alert_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Activity History table
CREATE TABLE activity_history (
    activity_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,                  -- who did the action (e.g., added a product)
    action_name VARCHAR(255) NOT NULL,     -- add, remove, edit, etc.
    entity_type VARCHAR(50) NOT NULL,      -- product, category, user, etc.
    entity_id INT NOT NULL,                -- id of the entity affected
    previous_value VARCHAR(255) NULL,              -- previous value before action
    new_value VARCHAR(255) NULL,                   -- new value after action
    affected_attribute VARCHAR(255) NULL,          -- which attributes were affected
    activity_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_activity_user 
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);
