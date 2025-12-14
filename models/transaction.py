from db import get_db_connection, close_db_connection
from mysql.connector import Error


class Transaction:

    @staticmethod
    def get_all(page=1, limit=10):
        connection = get_db_connection()
        if not connection:
            return False, "Database connection failed", 500

        try:
            offset = (page - 1) * limit
            cursor = connection.cursor(dictionary=True)

            # Get total count
            cursor.execute("SELECT COUNT(*) AS total FROM transactions")
            total = cursor.fetchone()["total"]

            # Get paginated transactions (most recent first)
            query = """
                SELECT 
                    t.transaction_id,
                    t.total_amount,
                    t.payment_method,
                    t.transaction_date,
                    u.full_name AS worker_name
                FROM transactions t
                JOIN users u ON t.worker_id = u.user_id
                ORDER BY t.transaction_date DESC
                LIMIT %s OFFSET %s
            """
            cursor.execute(query, (limit, offset))
            transactions = cursor.fetchall()

            cursor.close()

            return True, {
                "transactions": transactions,
                "page": page,
                "limit": limit,
                "total": total
            }, 200

        except Error as e:
            return False, f"Database error: {str(e)}", 500

        finally:
            close_db_connection(connection)

    @staticmethod
    def get_by_id(transaction_id):
        connection = get_db_connection()
        if not connection:
            return False, "Database connection failed", 500

        try:
            cursor = connection.cursor(dictionary=True)

            # Transaction header
            cursor.execute("""
                SELECT 
                    t.transaction_id,
                    t.total_amount,
                    t.payment_method,
                    t.transaction_date,
                    u.full_name AS worker_name
                FROM transactions t
                JOIN users u ON t.worker_id = u.user_id
                WHERE t.transaction_id = %s
            """, (transaction_id,))
            transaction = cursor.fetchone()

            if not transaction:
                cursor.close()
                return False, "Transaction not found", 404

            # Transaction items
            cursor.execute("""
                SELECT 
                    ti.product_id,
                    p.name AS product_name,
                    ti.quantity,
                    p.selling_price,
                    (ti.quantity * p.selling_price) AS subtotal
                FROM transaction_items ti
                JOIN products p ON ti.product_id = p.product_id
                WHERE ti.transaction_id = %s
            """, (transaction_id,))
            items = cursor.fetchall()

            transaction["items"] = items

            cursor.close()
            return True, transaction, 200

        except Error as e:
            return False, f"Database error: {str(e)}", 500

        finally:
            close_db_connection(connection)
