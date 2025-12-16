from flask import Blueprint, request, jsonify, g
from db import get_connection
import mysql.connector
from datetime import datetime
from routes.users import require_permission
from routes.activity_log import log_activity

# Added FEFO batch handling for POS with permission-protected endpoints

pos_bp = Blueprint('pos', __name__)

@pos_bp.route('/products', methods=['GET'])
def get_pos_products():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT 
            p.product_id as id,
            p.barcode,
            p.name,
            p.selling_price,
            COALESCE(SUM(pb.quantity), 0) AS quantity_in_stock
        FROM products p
        LEFT JOIN product_batches pb ON pb.product_id = p.product_id
        GROUP BY p.product_id, p.barcode, p.name, p.selling_price
        HAVING quantity_in_stock > 0
        ORDER BY p.name
    """)
    products = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify({'products': products})

@pos_bp.route('/transactions', methods=['POST'])
def create_pos_transaction():
    conn = None
    cursor = None
    try:
        data = request.get_json()
        if not data or not data.get('items'):
            return jsonify({'error': 'Items required'}), 400

        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO transactions (worker_id, total_amount, payment_method, transaction_date) 
            VALUES (%s, %s, %s, %s)
        """, (data['worker_id'], data['total_amount'], data['payment_method'], datetime.now()))
        transaction_id = cursor.lastrowid

        for item in data['items']:
            product_id = item['product_id']
            quantity = item['quantity']

            cursor.execute("""
                INSERT INTO transaction_items (transaction_id, product_id, quantity) 
                VALUES (%s, %s, %s)
            """, (transaction_id, product_id, quantity))

            _consume_batches_fefo(conn, product_id, quantity)

        log_activity(
            conn,
            g.current_user['user_id'],
            'create',
            'transaction',
            transaction_id,
            previous_value=None,
            new_value={'transaction_id': transaction_id, 'items': data['items'], 'total_amount': data['total_amount']},
            affected_attribute='transaction_items'
        )

        conn.commit()
        return jsonify({
            'status': 'success',
            'transaction_id': transaction_id
        }), 201

    except Exception as err:
        if conn:
            conn.rollback()
        return jsonify({'error': str(err)}), 400
    finally:
        if cursor:
            cursor.close()
        if conn and conn.is_connected():
            conn.close()


@pos_bp.route('/products/<int:product_id>/batches', methods=['GET'])
@require_permission('can_view_products')
def list_batches(product_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT batch_id, product_id, quantity, manifacture_date, expiry_date, supplier_id
        FROM product_batches
        WHERE product_id = %s
        ORDER BY 
            CASE WHEN expiry_date IS NULL THEN 1 ELSE 0 END,
            expiry_date ASC,
            batch_id ASC
    """, (product_id,))
    batches = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify({'batches': batches})


@pos_bp.route('/products/<int:product_id>/batches', methods=['POST'])
@require_permission('can_add_product')
def create_batch(product_id):
    conn = None
    try:
        data = request.get_json() or {}
        quantity = data.get('quantity')
        if quantity is None:
            return jsonify({'error': 'quantity is required'}), 400

        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO product_batches (product_id, quantity, manifacture_date, expiry_date, supplier_id)
            VALUES (%s, %s, %s, %s, %s)
        """, (product_id, int(quantity), data.get('manifacture_date'), data.get('expiry_date'), data.get('supplier_id')))
        batch_id = cursor.lastrowid
        _refresh_product_totals(conn, product_id)
        log_activity(
            conn,
            g.current_user['user_id'],
            'create',
            'batch',
            batch_id,
            previous_value=None,
            new_value={'product_id': product_id, 'quantity': int(quantity), 'expiry_date': data.get('expiry_date')},
            affected_attribute='product_batches'
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'batch_id': batch_id}), 201
    except Exception as err:
        if conn:
            conn.rollback()
            conn.close()
        return jsonify({'error': str(err)}), 400


@pos_bp.route('/batches/<int:batch_id>', methods=['PATCH'])
@require_permission('can_edit_product')
def update_batch(batch_id):
    conn = None
    try:
        data = request.get_json() or {}
        if not data:
            return jsonify({'error': 'No fields to update'}), 400

        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT product_id FROM product_batches WHERE batch_id = %s", (batch_id,))
        batch = cursor.fetchone()
        if not batch:
            cursor.close()
            conn.close()
            return jsonify({'error': 'Batch not found'}), 404

        update_fields = []
        params = []
        for field in ['quantity', 'manifacture_date', 'expiry_date', 'supplier_id']:
            if field in data:
                update_fields.append(f"{field} = %s")
                params.append(data[field])

        if not update_fields:
            cursor.close()
            conn.close()
            return jsonify({'error': 'No fields to update'}), 400

        params.append(batch_id)
        cursor.execute(f"UPDATE product_batches SET {', '.join(update_fields)} WHERE batch_id = %s", params)
        _refresh_product_totals(conn, batch['product_id'])
        log_activity(
            conn,
            g.current_user['user_id'],
            'update',
            'batch',
            batch_id,
            previous_value={'product_id': batch['product_id']},
            new_value=data,
            affected_attribute=', '.join(update_fields)
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Batch updated'})
    except Exception as err:
        if conn:
            conn.rollback()
            conn.close()
        return jsonify({'error': str(err)}), 400
