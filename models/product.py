from db import get_db_connection, close_db_connection
from mysql.connector import Error

class Product:
    @staticmethod
    def create(data):
        """
        Create a new product in the database.
        Returns (success, result/error_message, status_code)
        """
        connection = get_db_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            
            query = """
                INSERT INTO products 
                (barcode, name, category, qty, minStock, 
                 price, supplier, status, description)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            
            values = (
                data.get('barcode'),
                data.get('name'),
                data.get('category'),
                data.get('qty', 0),
                data.get('minStock', 0),
                float(data.get('price', 0.0)), 
                data.get('supplier'),
                'Out of stock' if data.get('qty', 0) == 0 else \
                   'Low stock' if data.get('qty', 0) <= data.get('minStock', 0) else \
                   'In stock',
                data.get('description')
            )
            
            cursor.execute(query, values)
            connection.commit()
            
            product_id = cursor.lastrowid
            
            # Fetch the created product
            cursor.execute("SELECT * FROM products WHERE product_id = %s", (product_id,))
            product = cursor.fetchone()
            
            cursor.close()
            return True, product, 201
            
        except Error as e:
            if "Duplicate entry" in str(e):
                if "barcode" in str(e):
                    return False, "Product with this barcode already exists", 400
                elif "name" in str(e):
                    return False, "Product with this name already exists", 400
            return False, f"Database error: {str(e)}", 500
        finally:
            close_db_connection(connection)
    
    @staticmethod
    def get_all():
        """
        Retrieve all products from the database.
        Returns (success, result/error_message, status_code)
        """
        connection = get_db_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM products ORDER BY created_at DESC")
            products = cursor.fetchall()
            cursor.close()
            return True, {
            "count": len(products),
            "products": products
            }, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_db_connection(connection)
    
    @staticmethod
    def get_by_id(product_id):
        """
        Retrieve a single product by ID.
        Returns (success, result/error_message, status_code)
        """
        connection = get_db_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM products WHERE product_id = %s", (product_id,))
            product = cursor.fetchone()
            cursor.close()
            
            if not product:
                return False, "Product not found", 404
            
            return True, product, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_db_connection(connection)
    
    @staticmethod
    def update(product_id, data):
        """
        Update a product's information.
        Returns (success, result/error_message, status_code)
        """
        connection = get_db_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            
            # Check if product exists
            cursor.execute("SELECT * FROM products WHERE product_id = %s", (product_id,))
            if not cursor.fetchone():
                cursor.close()
                return False, "Product not found", 404
            
            # Build dynamic update query based on provided fields
            update_fields = []
            values = []
            
            allowed_fields = ['barcode', 'name', 'category', 'qty', 'minStock', 
                            'price', 'supplier', 
                            'status', 'description']
            
            for field in allowed_fields:
                if field in data:
                    update_fields.append(f"{field} = %s")
                    values.append(data[field])
            
            if not update_fields:
                cursor.close()
                return False, "No valid fields to update", 400
            
            values.append(product_id)
            query = f"UPDATE products SET {', '.join(update_fields)} WHERE product_id = %s"
            
            cursor.execute(query, values)
            connection.commit()
            
            # Fetch the updated product
            cursor.execute("SELECT * FROM products WHERE product_id = %s", (product_id,))
            product = cursor.fetchone()
            
            cursor.close()
            return True, product, 200
            
        except Error as e:
            if "Duplicate entry" in str(e):
                if "barcode" in str(e):
                    return False, "Product with this barcode already exists", 400
                elif "name" in str(e):
                    return False, "Product with this name already exists", 400
            return False, f"Database error: {str(e)}", 500
        finally:
            close_db_connection(connection)
    
    @staticmethod
    def delete(product_id):
        """
        Delete a product from the database.
        Returns (success, result/error_message, status_code)
        """
        connection = get_db_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            
            # Check if product exists
            cursor.execute("SELECT * FROM products WHERE product_id = %s", (product_id,))
            if not cursor.fetchone():
                cursor.close()
                return False, "Product not found", 404
            
            cursor.execute("DELETE FROM products WHERE product_id = %s", (product_id,))
            connection.commit()
            cursor.close()
            
            return True, {"message": "Product deleted successfully"}, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_db_connection(connection)