import sqlite3

DB_PATH = "users.db"

def get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            full_name TEXT,
            email TEXT,
            phone TEXT,
            role TEXT,
            is_active INTEGER,
            created_at TEXT,
            password TEXT
        )
    """)

    conn.commit()
    conn.close()
