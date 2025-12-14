import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",     # your MySQL password
        database="stock_db"
    )
def close_connection(connection):
    if connection:
        try:
            if connection.is_connected():
                connection.close()
        except Exception as e:
            print("Error closing connection:", e)
