-- USERS
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    role VARCHAR(20) NOT NULL COMMENT 'Admin, Sales Clerk, Inventory Manager',
    can_view_products BOOLEAN DEFAULT FALSE,
    can_add_product BOOLEAN DEFAULT FALSE,
    can_edit_product BOOLEAN DEFAULT FALSE,
    can_delete_product BOOLEAN DEFAULT FALSE,
    can_view_activity_history BOOLEAN DEFAULT FALSE,
    can_set_alerts BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- PRODUCTS
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    barcode VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50) NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    qty INT NOT NULL DEFAULT 0,
    product_threshold INT,
    unit VARCHAR(20) NOT NULL DEFAULT 'piece',
    buying_price DECIMAL(10,2) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,
    supplier VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'In stock',
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TRANSACTIONS
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    worker_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL COMMENT 'Cash / Card',
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transactions_user
        FOREIGN KEY (worker_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- TRANSACTION ITEMS
CREATE TABLE transaction_items (
    transaction_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (transaction_id, product_id),
    CONSTRAINT fk_items_transaction
        FOREIGN KEY (transaction_id)
        REFERENCES transactions(transaction_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- CATEGORIES
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    category_description TEXT
);

-- SUPPLIERS
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(50) NOT NULL,
    supplier_description TEXT
);

-- PRODUCT BATCHES
CREATE TABLE product_batches (
    batch_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    manifacture_date DATE,
    expiry_date DATE,
    supplier_id INT,
    CONSTRAINT fk_batch_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_batch_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
        ON DELETE SET NULL
);

-- LOW STOCK ALERTS
CREATE TABLE low_stock_alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_alert_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE
);

-- ACTIVITY HISTORY
CREATE TABLE activity_history (
    activity_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    action_name VARCHAR(255) NOT NULL, --add delete update
    entity_type VARCHAR(50) NOT NULL, --product category ...
    entity_id INT NOT NULL,
    previous_value VARCHAR(255),
    new_value VARCHAR(255),
    affected_attribute VARCHAR(255), --example name 
    activity_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_activity_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    -- Indexes => added for faster search / access 
    INDEX idx_activity_user_date (user_id, activity_date),
    INDEX idx_activity_entity (entity_type, entity_id),
    INDEX idx_activity_date (activity_date)
);

-- THRESHOLDS
CREATE TABLE thresholds (
    threshold_id INT AUTO_INCREMENT PRIMARY KEY,
    threshold_type VARCHAR(20) NOT NULL COMMENT 'product or category',
    entity_id INT NULL COMMENT 'product_id if type=product, NULL if type=category',
    category_name VARCHAR(50) NULL COMMENT 'category name if type=category',
    threshold_value INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Ensure either entity_id or category_name is set based on type
    CONSTRAINT chk_threshold_type CHECK (
        (threshold_type = 'product' AND entity_id IS NOT NULL AND category_name IS NULL) OR
        (threshold_type = 'category' AND category_name IS NOT NULL AND entity_id IS NULL)
    ),
    
    -- Foreign key for product thresholds
    CONSTRAINT fk_threshold_product
        FOREIGN KEY (entity_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE,
    
    -- Indexes for faster lookups
    INDEX idx_threshold_type (threshold_type),
    INDEX idx_threshold_product (entity_id),
    INDEX idx_threshold_category (category_name)
);
