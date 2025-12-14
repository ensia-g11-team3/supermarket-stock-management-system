# app.py
from flask import Flask
from routes.pos_transaction import pos_bp
from routes.users import users_bp
from routes.activity import activity_bp
from routes.categories import categories_bp
from flask_cors import CORS

# Registered POS, user, and activity history blueprints

app = Flask(__name__)
CORS(app)

@app.route("/")
def home():
    return "Flask backend is running!"

app.register_blueprint(pos_bp)
app.register_blueprint(users_bp)
app.register_blueprint(activity_bp)
app.register_blueprint(categories_bp)

if __name__ == "__main__":
    app.run(debug=True)