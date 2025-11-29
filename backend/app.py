# app.py
from flask import Flask
from routes.pos_transaction import pos_bp  # import blueprint
from flask_cors import CORS

app = Flask(__name__)

CORS(app)

@app.route("/")
def home():
    return "Flask backend is running!"

# register routes from save_transactions.py
app.register_blueprint(pos_bp)

if __name__ == "__main__":
    app.run(debug=True)
