class Config:
    SQLALCHEMY_DATABASE_URI = "mysql+pymysql://user:password@localhost/pos_db"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = "your-secret-key"
