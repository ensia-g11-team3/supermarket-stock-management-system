from flask import Blueprint, request, jsonify
from models.category import Category

categories_bp = Blueprint("categories_bp", __name__)

# GET all categories
@categories_bp.route("/category", methods=["GET"])
def get_categories():
    success, result, status = Category.get_all()
    return jsonify(result), status

# POST create a category
@categories_bp.route("/category", methods=["POST"])
def create_category():
    data = request.get_json()
    success, result, status = Category.create(data)
    return jsonify(result), status

# GET category by ID
@categories_bp.route("/category/<int:category_id>", methods=["GET"])
def get_category(category_id):
    success, result, status = Category.get_by_id(category_id)
    return jsonify(result), status

# PUT update category
@categories_bp.route("/category/<int:category_id>", methods=["PUT"])
def update_category(category_id):
    data = request.get_json()
    success, result, status = Category.update(category_id, data)
    return jsonify(result), status

# DELETE category
@categories_bp.route("/category/<int:category_id>", methods=["DELETE"])
def delete_category(category_id):
    success, result, status = Category.delete(category_id)
    return jsonify(result), status
