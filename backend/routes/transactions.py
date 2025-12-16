from flask import Blueprint, request, jsonify
from models.transaction import Transaction

transactions_bp = Blueprint("transactions_bp", __name__)

# GET all transactions (Transaction History Page)
@transactions_bp.route("/", methods=["GET"])
def get_transactions():
    page = request.args.get("page", default=1, type=int)
    limit = request.args.get("limit", default=10, type=int)

    success, result, status = Transaction.get_all(page, limit)
    return jsonify(result), status


# GET transaction details (Click → Full Details)
@transactions_bp.route("/<int:transaction_id>", methods=["GET"])
def get_transaction(transaction_id):
    success, result, status = Transaction.get_by_id(transaction_id)
    return jsonify(result), status
