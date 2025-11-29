import os

class Config:
    # General app settings
    DEBUG = True
    SECRET_KEY = os.environ.get("SECRET_KEY", "super-secret-key")

    # CORS
    CORS_HEADERS = 'Content-Type'

    # Database configuration 
    DB_HOST = "localhost"
    DB_USER = "root"
    DB_PASSWORD = ""
    DB_NAME = "stock_db"

    # Full SQLAlchemy URI (if SQLAlchemy will be used later )
    SQLALCHEMY_DATABASE_URI = (
        f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
    )

    SQLALCHEMY_TRACK_MODIFICATIONS = False
