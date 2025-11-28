import mysql.connector
from mysql.connector import Error

def get_db_connection():
    """
    Create and return a database connection.
    Returns None if connection fails.
    """
    try:
        connection = mysql.connector.connect(
            host='localhost',
            user='root',
            password='',  # Change this to your MySQL password
            database='supermarket_db',
            port=3306
        )
        return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None

def close_db_connection(connection):
    """
    Close the database connection safely.
    """
    if connection and connection.is_connected():
        connection.close()