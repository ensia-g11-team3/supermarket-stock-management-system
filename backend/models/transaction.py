from db import get_connection, close_connection
from mysql.connector import Error
import sys


class Transaction:

    @staticmethod
    def get_all(page=1, limit=10, search=None, date=None, payment_method=None, worker_id=None):
        """Get all transactions with optional filtering"""
        connection = get_connection()
        if not connection:
            print("ERROR: Database connection failed", flush=True)
            return False, {"error": "Database connection failed"}, 500

        try:
            offset = (page - 1) * limit
            cursor = connection.cursor(dictionary=True)

            # Build WHERE clause
            where_conditions = []
            params = []

            print(f"\n{'='*60}", flush=True)
            print(f"TRANSACTION FILTER DEBUG", flush=True)
            print(f"{'='*60}", flush=True)
            print(f"Received parameters:", flush=True)
            print(f"  - search: '{search}'", flush=True)
            print(f"  - date: '{date}'", flush=True)
            print(f"  - payment_method: '{payment_method}'", flush=True)
            print(f"  - worker_id: '{worker_id}'", flush=True)
            print(f"  - page: {page}, limit: {limit}", flush=True)

            # Transaction ID search
            if search and str(search).strip():
                where_conditions.append("CAST(t.transaction_id AS CHAR) LIKE %s")
                params.append(f"{search}%")
                print(f"✓ Added search filter: transaction_id LIKE '{search}%'", flush=True)

            # Date filter
            if date and str(date).strip():
                where_conditions.append("DATE(t.transaction_date) = %s")
                params.append(date)
                print(f"✓ Added date filter: DATE = '{date}'", flush=True)

            # Payment method filter
            if payment_method and payment_method != 'All Methods':
                where_conditions.append("t.payment_method = %s")
                params.append(payment_method)
                print(f"✓ Added payment filter: payment_method = '{payment_method}'", flush=True)

            # Worker filter
            if worker_id:
                where_conditions.append("t.worker_id = %s")
                params.append(worker_id)
                print(f"✓ Added worker filter: worker_id = {worker_id}", flush=True)

            # Build WHERE clause
            where_clause = " AND ".join(where_conditions) if where_conditions else "1=1"
            
            print(f"\nFinal SQL WHERE clause: {where_clause}", flush=True)
            print(f"Parameters: {params}", flush=True)

            # Count total matching transactions
            count_query = f"SELECT COUNT(*) AS total FROM transactions t WHERE {where_clause}"
            print(f"\nExecuting COUNT query: {count_query}", flush=True)
            cursor.execute(count_query, tuple(params))
            total = cursor.fetchone()["total"]
            print(f"Total matching transactions: {total}", flush=True)

            # Get transactions
            query = f"""
                SELECT 
                    t.transaction_id,
                    t.total_amount,
                    t.payment_method,
                    t.transaction_date,
                    u.full_name AS worker_name,
                    u.user_id AS worker_id
                FROM transactions t
                JOIN users u ON t.worker_id = u.user_id
                WHERE {where_clause}
                ORDER BY t.transaction_date DESC
                LIMIT %s OFFSET %s
            """
            
            query_params = params + [limit, offset]
            print(f"\nExecuting SELECT query with LIMIT {limit} OFFSET {offset}", flush=True)
            cursor.execute(query, tuple(query_params))
            transactions = cursor.fetchall()
            
            print(f"Retrieved {len(transactions)} transactions", flush=True)
            if transactions:
                print(f"Transaction IDs: {[t['transaction_id'] for t in transactions]}", flush=True)
            print(f"{'='*60}\n", flush=True)

            cursor.close()
            sys.stdout.flush()

            return True, {
                "transactions": transactions,
                "page": page,
                "limit": limit,
                "total": total
            }, 200

        except Error as e:
            print(f"ERROR: Database error: {str(e)}", flush=True)
            sys.stdout.flush()
            return False, {"error": f"Database error: {str(e)}"}, 500

        finally:
            close_connection(connection)

    @staticmethod
    def get_by_id(transaction_id):
        """Get transaction details by ID"""
        connection = get_connection()
        if not connection:
            return False, {"error": "Database connection failed"}, 500

        try:
            cursor = connection.cursor(dictionary=True)

            # Get transaction
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
                return False, {"error": "Transaction not found"}, 404

            # Get items
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
            return False, {"error": f"Database error: {str(e)}"}, 500

        finally:
            close_connection(connection)

    @staticmethod
    def create_return(transaction_id):
        """Process transaction return"""
        connection = get_connection()
        if not connection:
            return False, {"error": "Database connection failed"}, 500

        try:
            cursor = connection.cursor(dictionary=True)

            # Check transaction exists
            cursor.execute("""
                SELECT transaction_id, status 
                FROM transactions 
                WHERE transaction_id = %s
            """, (transaction_id,))
            transaction = cursor.fetchone()

            if not transaction:
                cursor.close()
                return False, {"error": "Transaction not found"}, 404

            if transaction.get('status') == 'returned':
                cursor.close()
                return False, {"error": "Transaction already returned"}, 400

            # Get items
            cursor.execute("""
                SELECT product_id, quantity 
                FROM transaction_items 
                WHERE transaction_id = %s
            """, (transaction_id,))
            items = cursor.fetchall()

            if not items:
                cursor.close()
                return False, {"error": "No items found"}, 404

            # Restore stock
            for item in items:
                cursor.execute("""
                    UPDATE products 
                    SET qty = qty + %s 
                    WHERE product_id = %s
                """, (item['quantity'], item['product_id']))

                if cursor.rowcount == 0:
                    connection.rollback()
                    cursor.close()
                    return False, {"error": f"Failed to restore stock for product {item['product_id']}"}, 500

            # Update status
            cursor.execute("""
                UPDATE transactions 
                SET status = 'returned' 
                WHERE transaction_id = %s
            """, (transaction_id,))

            connection.commit()
            cursor.close()

            return True, {
                "message": "Transaction returned successfully",
                "transaction_id": transaction_id,
                "items_restored": len(items)
            }, 200

        except Error as e:
            if connection:
                connection.rollback()
            return False, {"error": f"Database error: {str(e)}"}, 500

        finally:
            close_connection(connection)
