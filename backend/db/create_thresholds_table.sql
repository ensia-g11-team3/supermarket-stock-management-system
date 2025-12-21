-- Create thresholds table for managing product and category low-stock thresholds
CREATE TABLE IF NOT EXISTS thresholds (
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
