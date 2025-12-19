from flask import Blueprint, request, jsonify
from routes.activity_log import log_activity
from db import get_connection
#from routes.users import require_permission

# Added activity history listing endpoint with permission gating

activity_bp = Blueprint('activity', __name__)


@activity_bp.route('/activity', methods=['GET'])
#@require_permission('can_view_activity_history')
def list_activity():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    page = int(request.args.get('page', 1))
    limit = int(request.args.get('limit', 50))
    offset = (page - 1) * limit
    entity_type = request.args.get('entity_type')
    user_id = request.args.get('user_id')

    query = """
        SELECT activity_id, user_id, action_name, entity_type, entity_id,
               previous_value, new_value, affected_attribute, activity_date
        FROM activity_history
        WHERE 1=1
    """
    params = []
    if entity_type:
        query += " AND entity_type = %s"
        params.append(entity_type)
    if user_id:
        query += " AND user_id = %s"
        params.append(user_id)

    query += " ORDER BY activity_date DESC LIMIT %s OFFSET %s"
    params.extend([limit, offset])

    cursor.execute(query, params)
    rows = cursor.fetchall()

    count_query = "SELECT COUNT(*) as total FROM activity_history WHERE 1=1"
    count_params = []
    if entity_type:
        count_query += " AND entity_type = %s"
        count_params.append(entity_type)
    if user_id:
        count_query += " AND user_id = %s"
        count_params.append(user_id)
    cursor.execute(count_query, count_params)
    total = cursor.fetchone()['total']

    cursor.close()
    conn.close()

    return jsonify({
        'activities': rows,
        'total': total,
        'page': page,
        'limit': limit,
        'total_pages': (total + limit - 1) // limit
    })

# POST route added by NOUR MALEK YAHIAOUI
@activity_bp.route('/activity', methods=['POST'])
def create_activity():
    data = request.get_json()
    conn = get_connection()
    try:
        log_activity(
            conn,
            user_id=data.get("user_id"),
            action_name=data.get("action_name"),
            entity_type=data.get("entity_type"),
            entity_id=data.get("entity_id"),
            previous_value=data.get("previous_value"),
            new_value=data.get("new_value"),
            affected_attribute=data.get("affected_attribute")
        )
        return jsonify({"message": "Activity logged"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500