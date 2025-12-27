from flask import Blueprint, request, jsonify
from models.transaction import Transaction
import sys

transactions_bp = Blueprint("transactions_bp", __name__)


@transactions_bp.route("/", methods=["GET"])
def get_transactions():
    """Get all transactions with optional filters"""
    
    # Get parameters
    page = request.args.get("page", default=1, type=int)
    limit = request.args.get("limit", default=10, type=int)
    search = request.args.get("search", default=None, type=str)
    date = request.args.get("date", default=None, type=str)
    payment_method = request.args.get("payment_method", default=None, type=str)
    worker_id = request.args.get("worker_id", default=None, type=int)

    print(f"\n{'*'*60}", flush=True)
    print(f"API ROUTE: GET /api/transactions", flush=True)
    print(f"{'*'*60}", flush=True)
    print(f"Request parameters:", flush=True)
    print(f"  page={page}, limit={limit}", flush=True)
    print(f"  search='{search}'", flush=True)
    print(f"  date='{date}'", flush=True)
    print(f"  payment_method='{payment_method}'", flush=True)
    print(f"  worker_id={worker_id}", flush=True)
    sys.stdout.flush()

    # Call model
    success, result, status = Transaction.get_all(
        page=page,
        limit=limit,
        search=search,
        date=date,
        payment_method=payment_method,
        worker_id=worker_id
    )
    
    print(f"\nAPI Response:", flush=True)
    print(f"  success={success}, status={status}", flush=True)
    if success:
        print(f"  transactions_count={len(result.get('transactions', []))}", flush=True)
        print(f"  total={result.get('total', 0)}", flush=True)
    else:
        print(f"  error={result.get('error', 'Unknown')}", flush=True)
    print(f"{'*'*60}\n", flush=True)
    sys.stdout.flush()
    
    return jsonify(result), status


@transactions_bp.route("/<int:transaction_id>", methods=["GET"])
def get_transaction(transaction_id):
    """Get transaction details"""
    print(f"\nAPI: GET /api/transactions/{transaction_id}", flush=True)
    success, result, status = Transaction.get_by_id(transaction_id)
    return jsonify(result), status


@transactions_bp.route("/<int:transaction_id>/return", methods=["POST"])
def return_transaction(transaction_id):
    """Return a transaction"""
    print(f"\nAPI: POST /api/transactions/{transaction_id}/return", flush=True)
    success, result, status = Transaction.create_return(transaction_id)
    return jsonify(result), status
