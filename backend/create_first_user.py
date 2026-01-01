# backend/create_first_user.py
import mysql.connector
import bcrypt
from db import get_connection

def prompt_user_input():
    """Prompt for user input and validate basic fields"""
    print("=== Create First Admin User ===")
    username = input("Username: ").strip()
    full_name = input("Full Name: ").strip()
    phone_number = input("Phone Number: ").strip()
    email = input("Email: ").strip()
    password = input("Password: ").strip()
    confirm_password = input("Confirm Password: ").strip()

    if not all([username, full_name, phone_number, email, password]):
        print("Error: All fields are required.")
        return None

    if password != confirm_password:
        print("Error: Passwords do not match.")
        return None

    return {
        'username': username,
        'full_name': full_name,
        'phone_number': phone_number,
        'email': email,
        'password': password,
        'role': 'Admin',
        'is_active': True
    }

def get_default_permissions(role):
    """Set default permissions based on role"""
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
    return permissions

def create_first_user():
    data = None
    while not data:
        data = prompt_user_input()

    try:
        conn = get_connection()
        cursor = conn.cursor()

        # Check if any users exist
        cursor.execute("SELECT COUNT(*) FROM users")
        if cursor.fetchone()[0] > 0:
            print("Users already exist in the system. You cannot create the first user now.")
            return

        # Hash the password
        password_hash = bcrypt.hashpw(data['password'].encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        permissions = get_default_permissions(data['role'])

        # Insert the first admin user
        cursor.execute("""
            INSERT INTO users (
                username, full_name, phone_number, email, password_hash, is_active, role,
                can_view_products, can_add_product, can_edit_product,
                can_delete_product, can_view_activity_history, can_set_alerts
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            data['username'], data['full_name'], data['phone_number'], data['email'],
            password_hash, data['is_active'], data['role'],
            permissions['can_view_products'], permissions['can_add_product'],
            permissions['can_edit_product'], permissions['can_delete_product'],
            permissions['can_view_activity_history'], permissions['can_set_alerts']
        ))

        conn.commit()
        print(f"Success! First admin user '{data['username']}' created.")
        cursor.close()
        conn.close()

    except mysql.connector.Error as err:
        print("Error:", err)
        if conn:
            conn.rollback()
            conn.close()

if __name__ == "__main__":
    create_first_user()
