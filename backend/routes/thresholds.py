from flask import Blueprint, jsonify, request
from models.threshold import Threshold

thresholds_bp = Blueprint("thresholds_bp", __name__)

@thresholds_bp.route("/", methods=["GET"])
def get_thresholds():
    """Get all thresholds"""
    success, result, status = Threshold.get_all()
    if success:
        return jsonify(result), status
    return jsonify({"error": result}), status

@thresholds_bp.route("/", methods=["POST"])
def create_threshold():
    """Create a new threshold"""
    data = request.get_json()
    
    if not data:
        return jsonify({"error": "No data provided"}), 400
    
    # Validate required fields
    if 'threshold_type' not in data:
        return jsonify({"error": "threshold_type is required"}), 400
    
    if 'threshold_value' not in data:
        return jsonify({"error": "threshold_value is required"}), 400
    
    threshold_type = data.get('threshold_type')
    
    if threshold_type == 'product' and 'product_id' not in data:
        return jsonify({"error": "product_id is required for product threshold"}), 400
    
    if threshold_type == 'category' and 'category_name' not in data:
        return jsonify({"error": "category_name is required for category threshold"}), 400
    
    success, result, status = Threshold.create(data)
    
    if success and threshold_type == 'category':
        # Apply category threshold to all products in that category
        category_name = data.get('category_name')
        threshold_value = data.get('threshold_value')
        Threshold.apply_category_threshold_to_products(category_name, threshold_value)
    
    if success:
        return jsonify(result), status
    return jsonify({"error": result}), status

@thresholds_bp.route("/<int:threshold_id>", methods=["GET"])
def get_threshold(threshold_id):
    """Get a specific threshold by ID"""
    success, result, status = Threshold.get_by_id(threshold_id)
    if success:
        return jsonify(result), status
    return jsonify({"error": result}), status

@thresholds_bp.route("/<int:threshold_id>", methods=["PUT"])
def update_threshold(threshold_id):
    """Update a threshold"""
    data = request.get_json()
    
    if not data:
        return jsonify({"error": "No data provided"}), 400
    
    success, result, status = Threshold.update(threshold_id, data)
    
    if success:
        # If it's a category threshold, reapply to products
        threshold_data = result
        if threshold_data.get('threshold_type') == 'category':
            category_name = threshold_data.get('category_name')
            threshold_value = threshold_data.get('threshold_value')
            Threshold.apply_category_threshold_to_products(category_name, threshold_value)
        
        return jsonify(result), status
    return jsonify({"error": result}), status

@thresholds_bp.route("/<int:threshold_id>", methods=["DELETE"])
def delete_threshold(threshold_id):
    """Delete a threshold"""
    success, result, status = Threshold.delete(threshold_id)
    if success:
        return jsonify(result), status
    return jsonify({"error": result}), status

@thresholds_bp.route("/category/<string:category_name>", methods=["GET"])
def get_category_threshold(category_name):
    """Check if a category has a threshold"""
    success, result, status = Threshold.get_by_category(category_name)
    if success:
        return jsonify(result), status
    return jsonify({"error": result}), status

@thresholds_bp.route("/product/<int:product_id>", methods=["GET"])
def get_product_threshold(product_id):
    """Get threshold for a specific product"""
    success, result, status = Threshold.get_by_product(product_id)
    if success:
        return jsonify(result), status
    return jsonify({"error": result}), status

@thresholds_bp.route("/product/<int:product_id>/effective", methods=["GET"])
def get_effective_threshold(product_id):
    """Get the effective threshold for a product (product-level or category-level)"""
    success, result, status = Threshold.get_effective_threshold(product_id)
    if success:
        return jsonify(result), status
    return jsonify({"error": result}), status

@thresholds_bp.route("/apply-category", methods=["POST"])
def apply_category_threshold():
    """Apply a category threshold to all products in that category"""
    data = request.get_json()
    
    if not data:
        return jsonify({"error": "No data provided"}), 400
    
    category_name = data.get('category_name')
    threshold_value = data.get('threshold_value')
    
    if not category_name or threshold_value is None:
        return jsonify({"error": "category_name and threshold_value are required"}), 400
    
    success, result, status = Threshold.apply_category_threshold_to_products(category_name, threshold_value)
    if success:
        return jsonify(result), status
    return jsonify({"error": result}), status
