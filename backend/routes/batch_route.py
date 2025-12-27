from flask import Blueprint, request, jsonify
from models.product_batch import ProductBatch

batch_bp = Blueprint('batches', __name__)

@batch_bp.route('/batches', methods=['POST'])
def create_batch():
    """
    Create a new product batch.
    Expects JSON body with batch data.
    """
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({"error": "Request body must be JSON"}), 400
        
        # Validate required fields
        if 'product_id' not in data:
            return jsonify({"error": "product_id is required"}), 400
        
        if 'quantity' not in data or data['quantity'] <= 0:
            return jsonify({"error": "quantity must be greater than 0"}), 400
        
        # Create batch
        success, result, status_code = ProductBatch.create(data)
        
        if success:
            return jsonify({
                "message": "Batch created successfully",
                "batch": result
            }), status_code
        else:
            return jsonify({"error": result}), status_code
            
    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500


@batch_bp.route('/batches', methods=['GET'])
def get_all_batches():
    """
    Get all batches in the system.
    """
    try:
        success, result, status_code = ProductBatch.get_all()
        
        if success:
            return jsonify(result), status_code
        else:
            return jsonify({"error": result}), status_code
            
    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500


@batch_bp.route('/products/<int:product_id>/batches', methods=['GET'])
def get_batches_by_product(product_id):
    """
    Get all batches for a specific product.
    """
    try:
        success, result, status_code = ProductBatch.get_by_product_id(product_id)
        
        if success:
            return jsonify(result), status_code
        else:
            return jsonify({"error": result}), status_code
            
    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500


@batch_bp.route('/batches/<int:batch_id>', methods=['GET'])
def get_batch(batch_id):
    """
    Get a single batch by ID.
    """
    try:
        success, result, status_code = ProductBatch.get_by_id(batch_id)
        
        if success:
            return jsonify({"batch": result}), status_code
        else:
            return jsonify({"error": result}), status_code
            
    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500


@batch_bp.route('/batches/<int:batch_id>', methods=['PUT'])
def update_batch(batch_id):
    """
    Update a batch's information.
    Expects JSON body with fields to update.
    """
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({"error": "Request body must be JSON"}), 400
        
        # Validate quantity if provided
        if 'quantity' in data and data['quantity'] <= 0:
            return jsonify({"error": "quantity must be greater than 0"}), 400
        
        # Update batch
        success, result, status_code = ProductBatch.update(batch_id, data)
        
        if success:
            return jsonify({
                "message": "Batch updated successfully",
                "batch": result
            }), status_code
        else:
            return jsonify({"error": result}), status_code
            
    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500


@batch_bp.route('/batches/<int:batch_id>', methods=['DELETE'])
def delete_batch(batch_id):
    """
    Delete a batch from the system.
    """
    try:
        success, result, status_code = ProductBatch.delete(batch_id)
        
        if success:
            return jsonify(result), status_code
        else:
            return jsonify({"error": result}), status_code
            
    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500


@batch_bp.route('/batches/expiring', methods=['GET'])
def get_expiring_batches():
    """
    Get batches expiring within specified days (default 30).
    Query param: days (optional)
    """
    try:
        days = request.args.get('days', 30, type=int)
        
        success, result, status_code = ProductBatch.get_expiring_batches(days)
        
        if success:
            return jsonify(result), status_code
        else:
            return jsonify({"error": result}), status_code
            
    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500


@batch_bp.route('/batches/expired', methods=['GET'])
def get_expired_batches():
    """
    Get all expired batches.
    """
    try:
        success, result, status_code = ProductBatch.get_expired_batches()
        
        if success:
            return jsonify(result), status_code
        else:
            return jsonify({"error": result}), status_code
            
    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500