# app.py
from flask import Flask
from routes.pos_transaction import pos_bp
from routes.users import users_bp
from routes.categories import categories_bp
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route("/")
def home():
    return "Flask backend is running!"

# Register blueprints
app.register_blueprint(pos_bp)
app.register_blueprint(users_bp)
app.register_blueprint(categories_bp)

if __name__ == "__main__":
    app.run(debug=True)