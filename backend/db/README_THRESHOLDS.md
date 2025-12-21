# Database Setup for Threshold Management System

## Quick Setup

### Step 1: Create the Thresholds Table

Run this SQL file to create the thresholds table:

```bash
# Using MySQL command line
mysql -u root -p stock_db < backend/db/create_thresholds_table.sql

# OR using phpMyAdmin or MySQL Workbench
# Open and execute: backend/db/create_thresholds_table.sql
```

### Step 2: Load Sample Data (Optional)

To test the threshold management system with sample data:

```bash
# Using MySQL command line
mysql -u root -p stock_db < backend/db/sample_data_thresholds.sql

# OR using phpMyAdmin or MySQL Workbench
# Open and execute: backend/db/sample_data_thresholds.sql
```

## What's Included in Sample Data

### Categories (5)
- Dairy
- Beverages
- Snacks
- Bakery
- Pantry

### Products (12)
- 3 Dairy products (Milk, Cheese, Yogurt)
- 3 Beverages (Orange Juice, Cola, Water)
- 2 Snacks (Chips, Chocolate)
- 2 Bakery items (Bread, Croissant)
- 2 Pantry items (Rice, Pasta)

### Thresholds
- **Category Thresholds**: 
  - Dairy: 10 units
  - Beverages: 20 units
- **Product Thresholds** (overriding category):
  - Cheddar Cheese: 5 units
  - Potato Chips: 15 units

## Verify Installation

After running the SQL files, verify the setup:

```sql
-- Check thresholds table exists
SHOW TABLES LIKE 'thresholds';

-- View all thresholds
SELECT * FROM thresholds;

-- View products with thresholds
SELECT name, category, qty, product_threshold FROM products;
```

## Start the Application

1. **Backend**:
   ```bash
   cd backend
   python app.py
   ```

2. **Frontend**:
   ```bash
   cd frontend
   flutter run -d windows
   ```

3. Navigate to **Thresholds** in the sidebar to manage thresholds!
