import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",     # your MySQL password
        database="stock_db"
    )
