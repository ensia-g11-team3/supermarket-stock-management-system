# routes/save_transactions.py
from flask import Blueprint, request, jsonify
from db import get_connection
import mysql.connector
from datetime import datetime

transactions_bp = Blueprint('transactions_bp', __name__)

@transactions_bp.route('/save_transaction', methods=['POST'])
def save_transaction():
    conn = None
    try:
        data = request.get_json()
        conn = get_connection()
        cursor = conn.cursor()

        # Insert main transaction
        cursor.execute("""
            INSERT INTO transactions (worker_id, total_amount, payment_method, transaction_date) 
            VALUES (%s, %s, %s, %s)
        """, (data['worker_id'], data['total_amount'], data['payment_method'], datetime.now()))

        transaction_id = cursor.lastrowid

        # Insert transaction items
        for item in data['items']:
            cursor.execute("""
                INSERT INTO transaction_items (transaction_id, product_id, quantity) 
                VALUES (%s, %s, %s)
            """, (transaction_id, item['product_id'], item['quantity']))

        conn.commit()

        return jsonify({
            'status': 'success',
            'transaction_id': transaction_id
        }), 201

    except mysql.connector.Error as err:
        if conn:
            conn.rollback()
        return jsonify({'error': str(err)}), 500
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
