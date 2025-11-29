from datetime import datetime

def validate_product_data(data, is_update=False):
    """
    Validate product data for creation or update.
    Returns (is_valid, error_message)
    """
    errors = []
    
    # Required fields for creation
    if not is_update:
        required_fields = ['barcode', 'name', 'category', 'buying_price', 'selling_price']
        for field in required_fields:
            if field not in data or not data[field]:
                errors.append(f"'{field}' is required")
    
    # Validate barcode
    if 'barcode' in data:
        if not isinstance(data['barcode'], str) or len(data['barcode']) > 50:
            errors.append("'barcode' must be a string with max 50 characters")
    
    # Validate name
    if 'name' in data:
        if not isinstance(data['name'], str) or len(data['name']) > 100:
            errors.append("'name' must be a string with max 100 characters")
    
    # Validate category
    if 'category' in data:
        if not isinstance(data['category'], str) or len(data['category']) > 50:
            errors.append("'category' must be a string with max 50 characters")
    
    # Validate quantity_in_stock
    if 'quantity_in_stock' in data:
        try:
            qty = int(data['quantity_in_stock'])
            if qty < 0:
                errors.append("'quantity_in_stock' must be non-negative")
        except (ValueError, TypeError):
            errors.append("'quantity_in_stock' must be a valid integer")
    
    # Validate unit
    if 'unit' in data:
        if not isinstance(data['unit'], str) or len(data['unit']) > 20:
            errors.append("'unit' must be a string with max 20 characters")
    
    # Validate buying_price
    if 'buying_price' in data:
        try:
            price = float(data['buying_price'])
            if price < 0:
                errors.append("'buying_price' must be non-negative")
        except (ValueError, TypeError):
            errors.append("'buying_price' must be a valid number")
    
    # Validate selling_price
    if 'selling_price' in data:
        try:
            price = float(data['selling_price'])
            if price < 0:
                errors.append("'selling_price' must be non-negative")
        except (ValueError, TypeError):
            errors.append("'selling_price' must be a valid number")
    
    # Validate expiry_date
    if 'expiry_date' in data and data['expiry_date']:
        try:
            datetime.strptime(data['expiry_date'], '%Y-%m-%d')
        except (ValueError, TypeError):
            errors.append("'expiry_date' must be in YYYY-MM-DD format")
    
    # Validate supplier
    if 'supplier' in data and data['supplier']:
        if not isinstance(data['supplier'], str) or len(data['supplier']) > 100:
            errors.append("'supplier' must be a string with max 100 characters")
    
    # Validate status
    if 'status' in data:
        valid_statuses = ['In stock', 'Low stock', 'Out of stock']
        if data['status'] not in valid_statuses:
            errors.append(f"'status' must be one of {valid_statuses}")
    
    if errors:
        return False, "; ".join(errors)
    
    return True, None