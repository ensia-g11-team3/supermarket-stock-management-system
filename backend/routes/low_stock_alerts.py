from flask import Blueprint, jsonify
from models.low_stock_alert import LowStockAlert

low_stock_alerts_bp = Blueprint("low_stock_alerts_bp", __name__)

@low_stock_alerts_bp.route("/", methods=["GET"])
def get_low_stock_alerts():
    success, result, status = LowStockAlert.get_all_active()
    return jsonify(result), status
