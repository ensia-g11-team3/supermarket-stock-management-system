from db import get_connection, close_connection
from mysql.connector import Error

class LowStockAlert:

    @staticmethod
    def create_if_needed(product_id):
        """
        Create an alert if product qty < threshold and no active alert exists
        """
        connection = get_connection()
        if not connection:
            return False

        try:
            cursor = connection.cursor(dictionary=True)

            query = """
                SELECT qty, product_threshold
                FROM products
                WHERE product_id = %s
            """
            cursor.execute(query, (product_id,))
            product = cursor.fetchone()

            if not product or product['product_threshold'] is None:
                return False

            if product['qty'] >= product['product_threshold']:
                return False

            cursor.execute("""
                SELECT alert_id FROM low_stock_alerts
                WHERE product_id = %s AND is_active = TRUE
            """, (product_id,))

            if cursor.fetchone():
                return False

            cursor.execute("""
                INSERT INTO low_stock_alerts (product_id)
                VALUES (%s)
            """, (product_id,))
            connection.commit()
            return True

        except Error:
            return False
        finally:
            close_connection(connection)

    @staticmethod
    def remove_if_resolved(product_id):
        """
        Deactivate alert if qty >= threshold
        """
        connection = get_connection()
        if not connection:
            return False

        try:
            cursor = connection.cursor(dictionary=True)

            query = """
                SELECT qty, product_threshold
                FROM products
                WHERE product_id = %s
            """
            cursor.execute(query, (product_id,))
            product = cursor.fetchone()

            if not product or product['product_threshold'] is None:
                return False

            if product['qty'] < product['product_threshold']:
                return False

            cursor.execute("""
                UPDATE low_stock_alerts
                SET is_active = FALSE
                WHERE product_id = %s AND is_active = TRUE
            """, (product_id,))
            connection.commit()
            return True

        except Error:
            return False
        finally:
            close_connection(connection)

    @staticmethod
    def get_all_active():
        """
        Data for the low_stock_alerts page
        """
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500

        try:
            cursor = connection.cursor(dictionary=True)

            query = """
                SELECT 
                    a.alert_id,
                    a.created_at,
                    p.product_id,
                    p.name,
                    p.category,
                    p.qty,
                    p.product_threshold,
                    p.unit
                FROM low_stock_alerts a
                JOIN products p ON a.product_id = p.product_id
                WHERE a.is_active = TRUE
                ORDER BY a.created_at DESC
            """
            cursor.execute(query)
            alerts = cursor.fetchall()
            cursor.close()

            return True, alerts, 200

        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
