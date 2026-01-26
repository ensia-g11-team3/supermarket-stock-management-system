import sys
import os
import bcrypt
from datetime import datetime, timedelta
import random

# Add the current directory to sys.path to make imports work
sys.path.append(os.getcwd())

from models.product import Product
from models.category import Category
from db import get_connection, close_connection
from mysql.connector import Error

# ============================================================================
# PRODUCT DATA
# ============================================================================
PRODUCT_DATA = """1	Lait Candia 1L	6130762000011	Dairy	Candia Algérie	120	110	140	Lait demi-écrémé
2	Yaourt Soummam Fraise	6130762100456	Dairy	Soummam	8	35	50	Yaourt aromatisé
3	Eau Ifri 1.5L	6130763001122	Beverages	Ifri	200	35	50	Eau minérale
4	Jus Rouiba Orange 1L	6130763100789	Beverages	Rouiba	60	140	180	Jus d'orange
5	Pain de mie Bimo	6130764000234	Bakery	Bimo	70	90	120	Pain tranché
6	Croissant Bimo	6130764000345	Bakery	Bimo	100	25	40	Viennoiserie
7	Spaghetti Amor 500g	6130765000567	Pasta	Amor Benamor	150	85	110	Pâtes alimentaires
8	Couscous Amor 1kg	6130765000789	Pasta	Amor Benamor	9	130	165	Semoule moyenne
9	Huile Elio 1L	6130766000123	Oil	Cevital	90	750	820	Huile végétale
10	Sucre Cristal 1kg	6130766000456	Grocery	Cevital	200	115	145	Sucre blanc
11	Café Noir Benamor	6130767000678	Grocery	Benamor	60	420	500	Café moulu
12	Riz Indien 1kg	6130767000890	Grocery	Local Supplier	110	150	190	Riz long grain
13	Thon El Manar 160g	6130768000129	Canned Food	El Manar	75	170	220	Thon à l'huile
14	Sardines en boîte	6130768000341	Canned Food	Belle Algérie	50	140	180	Sardines nature
15	Chocolat Moment	6130769000562	Snacks	Cevital	120	45	70	Chocolat au lait
16	Chips Chiki	6130769000784	Snacks	Chiki	9	60	90	Chips nature
17	Détergent Nadhif	6130770000125	Cleaning	Nadhif	40	320	390	Lessive poudre
18	Eau de javel 1L	6130770000347	Cleaning	Enad	60	70	100	Désinfectant
19	Savon Dove	6130771000568	Hygiene	Unilever Algérie	55	160	210	Savon doux
20	Dentifrice Signal	6130771000789	Hygiene	Unilever Algérie	45	230	290	Protection caries"""

# ============================================================================
# USER DATA
# ============================================================================
USER_DATA = [
    {
        'username': 'admin',
        'full_name': 'Ahmed Benali',
        'phone': '+213555123456',
        'email': 'ahmed.benali@gmail.com',
        'password': 'Admin@2024',
        'role': 'Admin'
    },
    {
        'username': 'caissier1',
        'full_name': 'Fatima Khelifi',
        'phone': '+213555234567',
        'email': 'fatima.khelifi@gmail.com',
        'password': 'Caissier@123',
        'role': 'POS Worker'
    },
    {
        'username': 'caissier2',
        'full_name': 'Youcef Mansouri',
        'phone': '+213555345678',
        'email': 'youcef.mansouri@gmail.com',
        'password': 'Caissier@123',
        'role': 'POS Worker'
    },
    {
        'username': 'gestionnaire1',
        'full_name': 'Amina Boudiaf',
        'phone': '+213555456789',
        'email': 'amina.boudiaf@gmail.com',
        'password': 'Gestionnaire@123',
        'role': 'Inventory Manager'
    },
    {
        'username': 'magasinier1',
        'full_name': 'Karim Zerrouki',
        'phone': '+213555567890',
        'email': 'karim.zerrouki@gmail.com',
        'password': 'Magasinier@123',
        'role': 'Inventory Staff'
    }
]

# ============================================================================
# SEED FUNCTIONS
# ============================================================================

def clean_database():
    """Clean all data from the database tables"""
    print("\n--- Cleaning Database ---")
    
    connection = get_connection()
    if not connection:
        print("Database connection failed")
        return False
    
    try:
        cursor = connection.cursor()
        
        # Disable foreign key checks temporarily
        cursor.execute("SET FOREIGN_KEY_CHECKS = 0")
        
        # List of tables to clean (in order to respect dependencies)
        tables = [
            'transaction_items',
            'transactions',
            'low_stock_alerts',
            'product_batches',
            'products',
            'categories',
            'activity_history',
            'users'
        ]
        
        for table in tables:
            try:
                cursor.execute(f"DELETE FROM {table}")
                print(f"✓ Cleared: {table}")
            except Error as e:
                print(f"⚠ Warning cleaning {table}: {e}")
        
        # Re-enable foreign key checks
        cursor.execute("SET FOREIGN_KEY_CHECKS = 1")
        
        connection.commit()
        cursor.close()
        print("Database cleaned successfully!")
        return True
        
    except Error as e:
        print(f"Error cleaning database: {e}")
        connection.rollback()
        return False
    finally:
        close_connection(connection)

def seed_products():
    """Seed products and categories"""
    print("\n--- Seeding Products & Categories ---")
    
    # Fetch existing categories
    success, categories, _ = Category.get_all()
    if not success:
        print(f"Error fetching categories: {categories}")
        return
    
    category_map = {c['category_name'].lower(): c['category_id'] for c in categories}
    print(f"Found {len(category_map)} existing categories.")
    
    lines = PRODUCT_DATA.strip().split('\n')
    created_count = 0
    
    for line in lines:
        parts = line.split('\t')
        if len(parts) < 9:
            continue
        
        name = parts[1].strip()
        barcode = parts[2].strip()
        category_name = parts[3].strip()
        supplier = parts[4].strip()
        qty = int(parts[5].strip())
        buying_price = float(parts[6].strip())
        selling_price = float(parts[7].strip())
        description = parts[8].strip()
        
        # Handle Category
        cat_key = category_name.lower()
        if cat_key not in category_map:
            print(f"Creating category: {category_name}")
            success, new_cat, _ = Category.create({
                'category_name': category_name,
                'category_description': f"Category for {category_name}"
            })
            if success:
                category_map[cat_key] = new_cat['category_id']
            else:
                print(f"Failed to create category {category_name}: {new_cat}")
                continue
        
        category_id = category_map[cat_key]
        
        # Create Product
        product_data = {
            'barcode': barcode,
            'name': name,
            'category_id': category_id,
            'qty': qty,
            'product_threshold': 10,
            'selling_price': selling_price,
            'buying_price': buying_price,
            'supplier': supplier,
            'description': description
        }
        
        success, result, _ = Product.create(product_data)
        if success:
            created_count += 1
            print(f"✓ Created: {name}")
        else:
            if "already exists" in str(result):
                print(f"⊘ Skipped: {name} (already exists)")
            else:
                print(f"✗ Failed: {name} - {result}")
    
    print(f"Products created: {created_count}/{len(lines)}")


def seed_users():
    """Seed users with different roles"""
    print("\n--- Seeding Users ---")
    
    user_ids = []
    
    for user_data in USER_DATA:
        user_id = create_user(
            user_data['username'],
            user_data['full_name'],
            user_data['phone'],
            user_data['email'],
            user_data['password'],
            user_data['role']
        )
        if user_id:
            user_ids.append((user_id, user_data['role']))
    
    print(f"Users created: {len(user_ids)}")
    return user_ids


def create_user(username, full_name, phone, email, password, role):
    """Create a user with specified role and permissions"""
    connection = get_connection()
    if not connection:
        return None
    
    try:
        cursor = connection.cursor(dictionary=True)
        
        # Check if user already exists
        cursor.execute("SELECT user_id FROM users WHERE username = %s", (username,))
        if cursor.fetchone():
            print(f"⊘ Skipped: {username} (already exists)")
            cursor.execute("SELECT user_id FROM users WHERE username = %s", (username,))
            user = cursor.fetchone()
            cursor.close()
            return user['user_id']
        
        # Hash password
        password_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        
        # Set permissions based on role (supports both English and French)
        permissions = {
            'Admin': {
                'can_view_products': True,
                'can_add_product': True,
                'can_edit_product': True,
                'can_delete_product': True,
                'can_view_activity_history': True,
                'can_set_alerts': True
            },
            'Administrateur': {
                'can_view_products': True,
                'can_add_product': True,
                'can_edit_product': True,
                'can_delete_product': True,
                'can_view_activity_history': True,
                'can_set_alerts': True
            },
            'Sales Clerk': {
                'can_view_products': True,
                'can_add_product': False,
                'can_edit_product': False,
                'can_delete_product': False,
                'can_view_activity_history': False,
                'can_set_alerts': False
            },
            'Caissier': {
                'can_view_products': True,
                'can_add_product': False,
                'can_edit_product': False,
                'can_delete_product': False,
                'can_view_activity_history': False,
                'can_set_alerts': False
            },
            'Inventory Manager': {
                'can_view_products': True,
                'can_add_product': True,
                'can_edit_product': True,
                'can_delete_product': False,
                'can_view_activity_history': True,
                'can_set_alerts': True
            },
            'Gestionnaire de Stock': {
                'can_view_products': True,
                'can_add_product': True,
                'can_edit_product': True,
                'can_delete_product': False,
                'can_view_activity_history': True,
                'can_set_alerts': True
            }
        }
        
        perms = permissions.get(role, permissions['Sales Clerk'])
        
        query = """
            INSERT INTO users 
            (username, full_name, phone_number, email, password_hash, is_active, role,
             can_view_products, can_add_product, can_edit_product, can_delete_product,
             can_view_activity_history, can_set_alerts)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        
        values = (
            username, full_name, phone, email, password_hash, True, role,
            perms['can_view_products'], perms['can_add_product'], perms['can_edit_product'],
            perms['can_delete_product'], perms['can_view_activity_history'], perms['can_set_alerts']
        )
        
        cursor.execute(query, values)
        connection.commit()
        user_id = cursor.lastrowid
        
        print(f"✓ Created: {username} ({role})")
        cursor.close()
        return user_id
        
    except Error as e:
        print(f"✗ Failed: {username} - {e}")
        return None
    finally:
        close_connection(connection)


def seed_transactions(user_ids, num_transactions=25):
    """Seed sample transactions"""
    print("\n--- Seeding Transactions ---")
    
    # Get sales workers
    sales_workers = [uid for uid, role in user_ids if role in ['Sales Clerk', 'Admin']]
    
    if not sales_workers:
        print("No sales workers available")
        return
    
    payment_methods = ['Cash', 'Card']
    created_count = 0
    
    for i in range(num_transactions):
        # Random date in the past 30 days
        days_ago = random.randint(0, 30)
        hours_ago = random.randint(0, 23)
        transaction_date = datetime.now() - timedelta(days=days_ago, hours=hours_ago)
        
        worker_id = random.choice(sales_workers)
        payment_method = random.choice(payment_methods)
        
        if create_transaction(worker_id, payment_method, transaction_date):
            created_count += 1
    
    print(f"Transactions created: {created_count}/{num_transactions}")


def create_transaction(worker_id, payment_method, transaction_date=None):
    """Create a transaction with random products"""
    connection = get_connection()
    if not connection:
        return False
    
    try:
        cursor = connection.cursor(dictionary=True)
        
        # Get available products
        cursor.execute("SELECT product_id, selling_price, qty FROM products WHERE qty > 0")
        products = cursor.fetchall()
        
        if not products:
            return False
        
        # Select 1-5 random products
        num_items = random.randint(1, min(5, len(products)))
        selected_products = random.sample(products, num_items)
        
        total_amount = 0
        items = []
        
        for product in selected_products:
            quantity = random.randint(1, min(3, product['qty']))
            item_total = float(product['selling_price']) * quantity
            total_amount += item_total
            items.append({
                'product_id': product['product_id'],
                'quantity': quantity
            })
        
        # Insert transaction
        trans_query = """
            INSERT INTO transactions (worker_id, total_amount, payment_method, transaction_date)
            VALUES (%s, %s, %s, %s)
        """
        
        trans_date = transaction_date if transaction_date else datetime.now()
        cursor.execute(trans_query, (worker_id, total_amount, payment_method, trans_date))
        transaction_id = cursor.lastrowid
        
        # Insert transaction items and update quantities
        for item in items:
            cursor.execute(
                "INSERT INTO transaction_items (transaction_id, product_id, quantity) VALUES (%s, %s, %s)",
                (transaction_id, item['product_id'], item['quantity'])
            )
            cursor.execute(
                "UPDATE products SET qty = qty - %s WHERE product_id = %s",
                (item['quantity'], item['product_id'])
            )
        
        connection.commit()
        print(f"✓ Transaction #{transaction_id}: {len(items)} items, {total_amount:.2f} DA ({payment_method})")
        cursor.close()
        return True
        
    except Error as e:
        print(f"✗ Transaction failed: {e}")
        connection.rollback()
        return False
    finally:
        close_connection(connection)


# ============================================================================
# MAIN SEED FUNCTION
# ============================================================================

def seed_all():
    """Seed all data: products, categories, users, and transactions"""
    print("=" * 70)
    print("NETTOYAGE ET INITIALISATION DE LA BASE DE DONNÉES")
    print("=" * 70)
    
    # 0. Clean existing data
    if not clean_database():
        print("❌ Database cleanup failed. Aborting seed.")
        return
    
    # 1. Seed Products & Categories
    seed_products()
    
    # 2. Seed Users
    user_ids = seed_users()
    
    # 3. Seed Transactions
    if user_ids:
        seed_transactions(user_ids, num_transactions=25)
    
    print("\n" + "=" * 70)
    print("✅ BASE DE DONNÉES INITIALISÉE AVEC SUCCÈS")
    print("=" * 70)
    print("\n📝 Identifiants de connexion:")
    print("  Administrateur:  admin / Admin@2024")
    print("  Caissiers:       caissier1, caissier2, caissier3 / Caissier@123")
    print("  Gestionnaire:    gestionnaire1 / Gestionnaire@123")
    print("=" * 70)


if __name__ == "__main__":
    seed_all()
