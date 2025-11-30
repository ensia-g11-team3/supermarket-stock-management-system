from flask import Blueprint, request, jsonify
from models.product import Product
from utils.validators import validate_product_data

product_bp = Blueprint('products', __name__)

@product_bp.route('/products', methods=['POST'])
def create_product():
    """
    Create a new product.
    Expects JSON body with product data.
    """
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({"error": "Request body must be JSON"}), 400
        
        # Validate input data
        is_valid, error_msg = validate_product_data(data)
        if not is_valid:
            return jsonify({"error": error_msg}), 400
        
        # Create product
        success, result, status_code = Product.create(data)
        
        if success:
            return jsonify({
                "message": "Product created successfully",
                "product": result
            }), status_code
        else:
            return jsonify({"error": result}), status_code
            
    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500

@product_bp.route('/products', methods=['GET'])
def get_all_products():
    """
    Get all products in the system.
    """
    try:
        success, result, status_code = Product.get_all()
        
        if success:
            return jsonify({
                "count": len(result),
                "products": result
            }), status_code
        else:
            return jsonify({"error": result}), status_code
            
    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500

@product_bp.route('/products/<int:product_id>', methods=['GET'])
def get_product(product_id):
    """
    Get a single product by ID.
    """
    try:
        success, result, status_code = Product.get_by_id(product_id)
        
        if success:
            return jsonify({"product": result}), status_code
        else:
            return jsonify({"error": result}), status_code
            
    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500

@product_bp.route('/products/<int:product_id>', methods=['PUT'])
def update_product(product_id):
    """
    Update a product's information.
    Expects JSON body with fields to update.
    """
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({"error": "Request body must be JSON"}), 400
        
        # Validate input data (for update)
        is_valid, error_msg = validate_product_data(data, is_update=True)
        if not is_valid:
            return jsonify({"error": error_msg}), 400
        
        # Update product
        success, result, status_code = Product.update(product_id, data)
        
        if success:
            return jsonify({
                "message": "Product updated successfully",
                "product": result
            }), status_code
        else:
            return jsonify({"error": result}), status_code
            
    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500

@product_bp.route('/products/<int:product_id>', methods=['DELETE'])
def delete_product(product_id):
    """
    Delete a product from the system.
    """
    try:
        success, result, status_code = Product.delete(product_id)
        
        if success:
            return jsonify(result), status_code
        else:
            return jsonify({"error": result}), status_code
            
    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500