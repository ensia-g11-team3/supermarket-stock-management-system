# routes/pos_transactions.py
from flask import Blueprint, request, jsonify
from db import get_connection
import mysql.connector
from datetime import datetime

pos_bp = Blueprint('pos', __name__)

@pos_bp.route('/pos/products', methods=['GET'])
def get_pos_products():
    """POS: Get available products (qty > 0)"""
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT product_id as id, barcode, name, selling_price, qty as quantity_in_stock
        FROM products 
        WHERE qty > 0
        ORDER BY name
    """)
    products = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify({'products': products})

@pos_bp.route('/pos/transactions', methods=['POST'])
def create_pos_transaction():
    """POS: Atomic transaction + stock deduction from qty"""
    conn = None
    try:
        data = request.get_json()
        if not data.get('items'):
            return jsonify({'error': 'Items required'}), 400
            
        conn = get_connection()
        cursor = conn.cursor()

        # Insert main transaction
        cursor.execute("""
            INSERT INTO transactions (worker_id, total_amount, payment_method, transaction_date) 
            VALUES (%s, %s, %s, %s)
        """, (data['worker_id'], data['total_amount'], data['payment_method'], datetime.now()))
        transaction_id = cursor.lastrowid

        # Atomic: save items + deduct qty
        for item in data['items']:
            product_id = item['product_id']
            quantity = item['quantity']
            
            # Save transaction item
            cursor.execute("""
                INSERT INTO transaction_items (transaction_id, product_id, quantity) 
                VALUES (%s, %s, %s)
            """, (transaction_id, product_id, quantity))
            
            # Deduct from qty (fails if insufficient)
            cursor.execute("""
                UPDATE products 
                SET qty = qty - %s 
                WHERE product_id = %s AND qty >= %s
            """, (quantity, product_id, quantity))
            
            if cursor.rowcount == 0:
                conn.rollback()
                return jsonify({'error': f'Insufficient stock for product {product_id}'}), 400

        conn.commit()
        return jsonify({
            'status': 'success',
            'transaction_id': transaction_id
        }), 201

    except Exception as err:
        if conn: conn.rollback()
        return jsonify({'error': str(err)}), 400
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
