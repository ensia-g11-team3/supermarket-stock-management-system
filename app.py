from flask import Flask, jsonify
from flask_cors import CORS
from config import Config
from routes.product_routes import product_bp

app = Flask(__name__)
app.config.from_object(Config)

# Enable CORS for frontend integration
CORS(app)

# Register blueprints
app.register_blueprint(product_bp, url_prefix='/api')

# Health check endpoint
@app.route('/api/health', methods=['GET'])
def health_check():
    """
    Health check endpoint to verify API is running.
    """
    return jsonify({
        "status": "healthy",
        "message": "Supermarket Stock Management API is running"
    }), 200

# Error handlers
@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": "Endpoint not found"}), 404

@app.errorhandler(405)
def method_not_allowed(error):
    return jsonify({"error": "Method not allowed"}), 405

@app.errorhandler(500)
def internal_error(error):
    return jsonify({"error": "Internal server error"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=Config.DEBUG)