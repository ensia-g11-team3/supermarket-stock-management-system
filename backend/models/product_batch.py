from db import get_connection, close_connection
from mysql.connector import Error

class ProductBatch:
    @staticmethod
    def create(data):
        """
        Create a new product batch in the database.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            
            query = """
                INSERT INTO product_batches 
                (product_id, quantity, manifacture_date, expiry_date)
                VALUES (%s, %s, %s, %s)
            """
            
            values = (
                data.get('product_id'),
                data.get('quantity', 0),
                data.get('manufacture_date'),  # User sends 'manufacture_date'
                data.get('expiry_date'),
            )
            
            cursor.execute(query, values)
            connection.commit()
            
            batch_id = cursor.lastrowid
            
            # Fetch the created batch
            cursor.execute("""
                SELECT pb.*, p.name as product_name 
                FROM product_batches pb
                LEFT JOIN products p ON pb.product_id = p.product_id
                WHERE pb.batch_id = %s
            """, (batch_id,))
            batch = cursor.fetchone()
            
            cursor.close()
            return True, batch, 201
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def get_all():
        """
        Retrieve all product batches from the database.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("""
                SELECT pb.*, p.name as product_name
                FROM product_batches pb
                LEFT JOIN products p ON pb.product_id = p.product_id
                ORDER BY pb.batch_id DESC
            """)
            batches = cursor.fetchall()
            cursor.close()
            return True, {
                "count": len(batches),
                "batches": batches
            }, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def get_by_product_id(product_id):
        """
        Retrieve all batches for a specific product.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("""
                SELECT pb.*, p.name as product_name
                FROM product_batches pb
                LEFT JOIN products p ON pb.product_id = p.product_id
                WHERE pb.product_id = %s
                ORDER BY pb.expiry_date ASC, pb.batch_id DESC
            """, (product_id,))
            batches = cursor.fetchall()
            cursor.close()
            
            return True, {
                "count": len(batches),
                "batches": batches
            }, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def get_by_id(batch_id):
        """
        Retrieve a single batch by ID.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("""
                SELECT pb.*, p.name as product_name
                FROM product_batches pb
                LEFT JOIN products p ON pb.product_id = p.product_id
                WHERE pb.batch_id = %s
            """, (batch_id,))
            batch = cursor.fetchone()
            cursor.close()
            
            if not batch:
                return False, "Batch not found", 404
            
            return True, batch, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def update(batch_id, data):
        """
        Update a batch's information.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            
            # Check if batch exists
            cursor.execute("SELECT * FROM product_batches WHERE batch_id = %s", (batch_id,))
            if not cursor.fetchone():
                cursor.close()
                return False, "Batch not found", 404
            
            # Build dynamic update query based on provided fields
            update_fields = []
            values = []
            
            # Map user-friendly field names to actual column names
            field_mapping = {
                'product_id': 'product_id',
                'quantity': 'quantity',
                'manufacture_date': 'manifacture_date',  # Map to actual column
                'expiry_date': 'expiry_date'
            }
            
            for user_field, db_field in field_mapping.items():
                if user_field in data:
                    update_fields.append(f"{db_field} = %s")
                    values.append(data[user_field])
            
            if not update_fields:
                cursor.close()
                return False, "No valid fields to update", 400
            
            values.append(batch_id)
            query = f"UPDATE product_batches SET {', '.join(update_fields)} WHERE batch_id = %s"
            
            cursor.execute(query, values)
            connection.commit()
            
            # Fetch the updated batch
            cursor.execute("""
                SELECT pb.*, p.name as product_name
                FROM product_batches pb
                LEFT JOIN products p ON pb.product_id = p.product_id
                WHERE pb.batch_id = %s
            """, (batch_id,))
            batch = cursor.fetchone()
            
            cursor.close()
            return True, batch, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def delete(batch_id):
        """
        Delete a batch from the database.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            
            # Check if batch exists
            cursor.execute("SELECT * FROM product_batches WHERE batch_id = %s", (batch_id,))
            if not cursor.fetchone():
                cursor.close()
                return False, "Batch not found", 404
            
            cursor.execute("DELETE FROM product_batches WHERE batch_id = %s", (batch_id,))
            connection.commit()
            cursor.close()
            
            return True, {"message": "Batch deleted successfully"}, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def get_expiring_batches(days=30):
        """
        Get batches expiring within specified days.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("""
                SELECT pb.*, p.name as product_name
                FROM product_batches pb
                LEFT JOIN products p ON pb.product_id = p.product_id
                WHERE pb.expiry_date IS NOT NULL 
                AND pb.expiry_date <= DATE_ADD(CURDATE(), INTERVAL %s DAY)
                AND pb.expiry_date >= CURDATE()
                ORDER BY pb.expiry_date ASC
            """, (days,))
            batches = cursor.fetchall()
            cursor.close()
            
            return True, {
                "count": len(batches),
                "batches": batches
            }, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
    
    @staticmethod
    def get_expired_batches():
        """
        Get all expired batches.
        Returns (success, result/error_message, status_code)
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("""
                SELECT pb.*, p.name as product_name
                FROM product_batches pb
                LEFT JOIN products p ON pb.product_id = p.product_id
                WHERE pb.expiry_date IS NOT NULL 
                AND pb.expiry_date < CURDATE()
                ORDER BY pb.expiry_date DESC
            """)
            batches = cursor.fetchall()
            cursor.close()
            
            return True, {
                "count": len(batches),
                "batches": batches
            }, 200
            
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)