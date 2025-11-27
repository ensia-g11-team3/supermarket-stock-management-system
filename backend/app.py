# app.py
from flask import Flask
from routes.save_transactions import transactions_bp  # import blueprint

app = Flask(__name__)

@app.route("/")
def home():
    return "Flask backend is running!"

# register routes from save_transactions.py
app.register_blueprint(transactions_bp)

if __name__ == "__main__":
    app.run(debug=True)
