# backend/routes/users.py
from flask import Blueprint, request, jsonify
from db import get_connection
import mysql.connector
import bcrypt

users_bp = Blueprint('users', __name__)

@users_bp.route('/users', methods=['GET'])
def get_users():
    """Get all users with filtering and pagination"""
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        
        # Get query parameters
        search = request.args.get('search', '')
        role = request.args.get('role', '')
        status_filter = request.args.get('status', '')
        page = int(request.args.get('page', 1))
        limit = int(request.args.get('limit', 50))
        offset = (page - 1) * limit
        
        # Build query
        query = """
            SELECT 
                user_id, username, full_name, phone_number, email, 
                role, password_hash,
                can_view_products, can_add_product, can_edit_product,
                can_delete_product, can_view_activity_history, can_set_alerts,
                created_at
            FROM users 
            WHERE 1=1
        """
        params = []
        
        if search:
            query += " AND (username LIKE %s OR full_name LIKE %s OR email LIKE %s OR phone_number LIKE %s)"
            search_term = f"%{search}%"
            params.extend([search_term, search_term, search_term, search_term])
        
        if role and role != 'All Roles':
            query += " AND role = %s"
            params.append(role)
            
        # Note: Your table doesn't have a 'status' column, so we'll use role-based filtering instead
        if status_filter and status_filter != 'All Status':
            # You can implement status logic later if you add a status column
            pass
        
        query += " ORDER BY created_at DESC LIMIT %s OFFSET %s"
        params.extend([limit, offset])
        
        cursor.execute(query, params)
        users = cursor.fetchall()
        
        # Convert to proper Python types and don't return password_hash
        for user in users:
            user['user_id'] = int(user['user_id'])
            # Convert tinyint(1) to boolean for permissions
            for perm_key in ['can_view_products', 'can_add_product', 'can_edit_product', 
                           'can_delete_product', 'can_view_activity_history', 'can_set_alerts']:
                user[perm_key] = bool(user[perm_key])
            # Remove password hash from response
            if 'password_hash' in user:
                del user['password_hash']
        
        # Get total count for pagination
        count_query = "SELECT COUNT(*) as total FROM users WHERE 1=1"
        count_params = []
        
        if search:
            count_query += " AND (username LIKE %s OR full_name LIKE %s OR email LIKE %s OR phone_number LIKE %s)"
            count_params.extend([search_term, search_term, search_term, search_term])
        
        if role and role != 'All Roles':
            count_query += " AND role = %s"
            count_params.append(role)
        
        cursor.execute(count_query, count_params)
        total_result = cursor.fetchone()
        total = total_result['total'] if total_result else 0
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'users': users,
            'total': total,
            'page': page,
            'limit': limit,
            'total_pages': (total + limit - 1) // limit
        })
        
    except Exception as err:
        if conn:
            conn.close()
        return jsonify({'error': str(err)}), 500

@users_bp.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    """Get a specific user by ID"""
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        
        cursor.execute("""
            SELECT 
                user_id, username, full_name, phone_number, email, 
                role, password_hash,
                can_view_products, can_add_product, can_edit_product,
                can_delete_product, can_view_activity_history, can_set_alerts,
                created_at
            FROM users 
            WHERE user_id = %s
        """, (user_id,))
        
        user = cursor.fetchone()
        
        if user:
            # Convert to proper Python types and don't return password_hash
            user['user_id'] = int(user['user_id'])
            for perm_key in ['can_view_products', 'can_add_product', 'can_edit_product', 
                           'can_delete_product', 'can_view_activity_history', 'can_set_alerts']:
                user[perm_key] = bool(user[perm_key])
            # Remove password hash from response
            if 'password_hash' in user:
                del user['password_hash']
        
        cursor.close()
        conn.close()
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
            
        return jsonify({'user': user})
        
    except Exception as err:
        if conn:
            conn.close()
        return jsonify({'error': str(err)}), 500

@users_bp.route('/users', methods=['POST'])
def create_user():
    """Create a new user with all attributes"""
    conn = None
    try:
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['username', 'full_name', 'phone_number', 'email', 'password', 'role']
        for field in required_fields:
            if not data.get(field):
                return jsonify({'error': f'{field} is required'}), 400
        
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        
        # Check if username or email already exists
        cursor.execute("SELECT user_id FROM users WHERE username = %s OR email = %s", 
                      (data['username'], data['email']))
        existing_user = cursor.fetchone()
        if existing_user:
            return jsonify({'error': 'Username or email already exists'}), 400
        
        # Hash password
        password_hash = bcrypt.hashpw(data['password'].encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        
        # Set permissions based on role or use provided permissions
        permissions = _get_default_permissions(data['role'])
        
        # Override with provided permissions if any
        for perm_key in ['can_view_products', 'can_add_product', 'can_edit_product',
                        'can_delete_product', 'can_view_activity_history', 'can_set_alerts']:
            if perm_key in data:
                permissions[perm_key] = bool(data[perm_key])
        
        # Insert user with all permissions
        cursor.execute("""
            INSERT INTO users (
                username, full_name, phone_number, email, password_hash, role,
                can_view_products, can_add_product, can_edit_product,
                can_delete_product, can_view_activity_history, can_set_alerts
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            data['username'], data['full_name'], data['phone_number'], data['email'],
            password_hash, data['role'],
            permissions['can_view_products'], permissions['can_add_product'], 
            permissions['can_edit_product'], permissions['can_delete_product'],
            permissions['can_view_activity_history'], permissions['can_set_alerts']
        ))
        
        user_id = cursor.lastrowid
        conn.commit()
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'message': 'User created successfully',
            'user_id': user_id
        }), 201
        
    except Exception as err:
        if conn:
            conn.rollback()
            conn.close()
        return jsonify({'error': str(err)}), 500

@users_bp.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    """Update an existing user with all attributes"""
    conn = None
    try:
        data = request.get_json()
        
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        
        # Check if user exists
        cursor.execute("SELECT user_id FROM users WHERE user_id = %s", (user_id,))
        if not cursor.fetchone():
            return jsonify({'error': 'User not found'}), 404
        
        # Build update query dynamically
        update_fields = []
        params = []
        
        # Basic info fields
        basic_fields = ['username', 'full_name', 'phone_number', 'email', 'role']
        for field in basic_fields:
            if field in data:
                update_fields.append(f"{field} = %s")
                params.append(data[field])
        
        # Permission fields
        perm_fields = ['can_view_products', 'can_add_product', 'can_edit_product',
                      'can_delete_product', 'can_view_activity_history', 'can_set_alerts']
        for field in perm_fields:
            if field in data:
                update_fields.append(f"{field} = %s")
                params.append(bool(data[field]))
        
        # Handle password reset
        if data.get('reset_password') and data.get('new_password'):
            password_hash = bcrypt.hashpw(data['new_password'].encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
            update_fields.append("password_hash = %s")
            params.append(password_hash)
        
        if not update_fields:
            return jsonify({'error': 'No fields to update'}), 400
        
        params.append(user_id)
        query = f"UPDATE users SET {', '.join(update_fields)} WHERE user_id = %s"
        
        cursor.execute(query, params)
        conn.commit()
        
        cursor.close()
        conn.close()
        
        return jsonify({'message': 'User updated successfully'})
        
    except Exception as err:
        if conn:
            conn.rollback()
            conn.close()
        return jsonify({'error': str(err)}), 500

@users_bp.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    """Delete a user"""
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        
        # Check if user exists
        cursor.execute("SELECT user_id FROM users WHERE user_id = %s", (user_id,))
        if not cursor.fetchone():
            return jsonify({'error': 'User not found'}), 404
        
        # Delete user
        cursor.execute("DELETE FROM users WHERE user_id = %s", (user_id,))
        conn.commit()
        
        cursor.close()
        conn.close()
        
        return jsonify({'message': 'User deleted successfully'})
        
    except Exception as err:
        if conn:
            conn.rollback()
            conn.close()
        return jsonify({'error': str(err)}), 500

def _get_default_permissions(role):
    """Get default permissions based on role"""
    permissions = {
        'can_view_products': False,
        'can_add_product': False,
        'can_edit_product': False,
        'can_delete_product': False,
        'can_view_activity_history': False,
        'can_set_alerts': False
    }
    
    role_lower = role.lower()
    if role_lower == 'admin':
        permissions.update({key: True for key in permissions})
    elif 'manager' in role_lower:
        permissions.update({
            'can_view_products': True,
            'can_add_product': True,
            'can_edit_product': True,
            'can_view_activity_history': True,
            'can_set_alerts': True
        })
    elif 'pos' in role_lower or 'worker' in role_lower:
        permissions.update({
            'can_view_products': True
        })
    
    return permissions