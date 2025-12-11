import json

# Added shared helper to record activity history entries


def log_activity(conn, user_id, action_name, entity_type, entity_id, previous_value=None, new_value=None, affected_attribute=None):
    payload_prev = json.dumps(previous_value, default=str) if previous_value is not None else None
    payload_new = json.dumps(new_value, default=str) if new_value is not None else None
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO activity_history (
            user_id, action_name, entity_type, entity_id,
            previous_value, new_value, affected_attribute
        ) VALUES (%s, %s, %s, %s, %s, %s, %s)
    """, (
        user_id,
        action_name,
        entity_type,
        entity_id,
        payload_prev,
        payload_new,
        affected_attribute
    ))
    cursor.close()

