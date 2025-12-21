from db import get_connection, close_connection
from mysql.connector import Error

class Threshold:
    @staticmethod
    def create(data):
        """
        Create a new threshold for a product or category.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            
            threshold_type = data.get('threshold_type')
            threshold_value = data.get('threshold_value')
            
            if threshold_type not in ['product', 'category']:
                return False, "Invalid threshold type. Must be 'product' or 'category'", 400
            
            if threshold_type == 'product':
                product_id = data.get('product_id')
                if not product_id:
                    return False, "product_id is required for product threshold", 400
                
                # Check if product exists
                cursor.execute("SELECT product_id FROM products WHERE product_id = %s", (product_id,))
                if not cursor.fetchone():
                    return False, "Product not found", 404
                
                # Check if threshold already exists for this product
                cursor.execute(
                    "SELECT threshold_id FROM thresholds WHERE threshold_type = 'product' AND entity_id = %s",
                    (product_id,)
                )
                if cursor.fetchone():
                    return False, "Threshold already exists for this product. Use update instead.", 400
                
                query = """
                    INSERT INTO thresholds (threshold_type, entity_id, threshold_value)
                    VALUES (%s, %s, %s)
                """
                values = (threshold_type, product_id, threshold_value)
                
            else:  # category
                category_name = data.get('category_name')
                if not category_name:
                    return False, "category_name is required for category threshold", 400
                
                # Check if category exists
                cursor.execute("SELECT category_id FROM categories WHERE category_name = %s", (category_name,))
                if not cursor.fetchone():
                    return False, "Category not found", 404
                
                # Check if threshold already exists for this category
                cursor.execute(
                    "SELECT threshold_id FROM thresholds WHERE threshold_type = 'category' AND category_name = %s",
                    (category_name,)
                )
                if cursor.fetchone():
                    return False, "Threshold already exists for this category. Use update instead.", 400
                
                query = """
                    INSERT INTO thresholds (threshold_type, category_name, threshold_value)
                    VALUES (%s, %s, %s)
                """
                values = (threshold_type, category_name, threshold_value)
            
            cursor.execute(query, values)
            connection.commit()
            
            threshold_id = cursor.lastrowid
            
            # Fetch the created threshold
            cursor.execute("SELECT * FROM thresholds WHERE threshold_id = %s", (threshold_id,))
            threshold = cursor.fetchone()
            
            cursor.close()
            return True, threshold, 201
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def get_all():
        """
        Retrieve all thresholds from the database.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            
            query = """
                SELECT 
                    t.*,
                    CASE 
                        WHEN t.threshold_type = 'product' THEN p.name
                        WHEN t.threshold_type = 'category' THEN t.category_name
                    END as entity_name
                FROM thresholds t
                LEFT JOIN products p ON t.threshold_type = 'product' AND t.entity_id = p.product_id
                ORDER BY t.created_at DESC
            """
            
            cursor.execute(query)
            thresholds = cursor.fetchall()
            cursor.close()
            
            return True, {
                "count": len(thresholds),
                "thresholds": thresholds
            }, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def get_by_id(threshold_id):
        """
        Retrieve a single threshold by ID.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            
            query = """
                SELECT 
                    t.*,
                    CASE 
                        WHEN t.threshold_type = 'product' THEN p.name
                        WHEN t.threshold_type = 'category' THEN t.category_name
                    END as entity_name
                FROM thresholds t
                LEFT JOIN products p ON t.threshold_type = 'product' AND t.entity_id = p.product_id
                WHERE t.threshold_id = %s
            """
            
            cursor.execute(query, (threshold_id,))
            threshold = cursor.fetchone()
            cursor.close()
            
            if not threshold:
                return False, "Threshold not found", 404
            
            return True, threshold, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def get_by_category(category_name):
        """
        Check if a category has a threshold set.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute(
                "SELECT * FROM thresholds WHERE threshold_type = 'category' AND category_name = %s",
                (category_name,)
            )
            threshold = cursor.fetchone()
            cursor.close()
            
            if not threshold:
                return True, {"exists": False, "threshold": None}, 200
            
            return True, {"exists": True, "threshold": threshold}, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def get_by_product(product_id):
        """
        Get threshold for a specific product.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute(
                "SELECT * FROM thresholds WHERE threshold_type = 'product' AND entity_id = %s",
                (product_id,)
            )
            threshold = cursor.fetchone()
            cursor.close()
            
            if not threshold:
                return True, {"exists": False, "threshold": None}, 200
            
            return True, {"exists": True, "threshold": threshold}, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def update(threshold_id, data):
        """
        Update a threshold's value.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            
            # Check if threshold exists
            cursor.execute("SELECT * FROM thresholds WHERE threshold_id = %s", (threshold_id,))
            existing = cursor.fetchone()
            if not existing:
                cursor.close()
                return False, "Threshold not found", 404
            
            threshold_value = data.get('threshold_value')
            if threshold_value is None:
                cursor.close()
                return False, "threshold_value is required", 400
            
            query = "UPDATE thresholds SET threshold_value = %s WHERE threshold_id = %s"
            cursor.execute(query, (threshold_value, threshold_id))
            connection.commit()
            
            # Fetch the updated threshold
            cursor.execute("SELECT * FROM thresholds WHERE threshold_id = %s", (threshold_id,))
            threshold = cursor.fetchone()
            
            cursor.close()
            return True, threshold, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def delete(threshold_id):
        """
        Delete a threshold from the database.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            
            # Check if threshold exists
            cursor.execute("SELECT * FROM thresholds WHERE threshold_id = %s", (threshold_id,))
            if not cursor.fetchone():
                cursor.close()
                return False, "Threshold not found", 404
            
            cursor.execute("DELETE FROM thresholds WHERE threshold_id = %s", (threshold_id,))
            connection.commit()
            cursor.close()
            
            return True, {"message": "Threshold deleted successfully"}, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def apply_category_threshold_to_products(category_name, threshold_value):
        """
        Apply a category threshold to all products in that category.
        Updates product_threshold for all products in the category.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            
            # Update all products in the category
            query = """
                UPDATE products 
                SET product_threshold = %s 
                WHERE category = %s
            """
            cursor.execute(query, (threshold_value, category_name))
            connection.commit()
            
            affected_rows = cursor.rowcount
            cursor.close()
            
            return True, {
                "message": f"Category threshold applied to {affected_rows} products",
                "affected_count": affected_rows
            }, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def get_effective_threshold(product_id):
        """
        Get the effective threshold for a product.
        First checks product-level threshold, then falls back to category threshold.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            
            # Get product info
            cursor.execute(
                "SELECT product_threshold, category FROM products WHERE product_id = %s",
                (product_id,)
            )
            product = cursor.fetchone()
            
            if not product:
                cursor.close()
                return False, "Product not found", 404
            
            # If product has its own threshold, use it
            if product['product_threshold'] is not None:
                cursor.close()
                return True, {
                    "threshold": product['product_threshold'],
                    "source": "product"
                }, 200
            
            # Otherwise, check for category threshold
            cursor.execute(
                "SELECT threshold_value FROM thresholds WHERE threshold_type = 'category' AND category_name = %s",
                (product['category'],)
            )
            category_threshold = cursor.fetchone()
            cursor.close()
            
            if category_threshold:
                return True, {
                    "threshold": category_threshold['threshold_value'],
                    "source": "category"
                }, 200
            
            return True, {
                "threshold": None,
                "source": "none"
            }, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
