from multiprocessing import connection
from db import get_connection, close_connection
from mysql.connector import Error

class Category:
    @staticmethod
    def create(data):
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        try:
            cursor = connection.cursor(dictionary=True)
            query = "INSERT INTO categories (category_name, category_description) VALUES (%s, %s)"
            values = (
                data.get('category_name'),
                data.get('category_description', '')
            )
            cursor.execute(query, values)
            connection.commit()
            category_id = cursor.lastrowid
            cursor.execute("SELECT * FROM categories WHERE category_id = %s", (category_id,))
            category = cursor.fetchone()
            cursor.close()
            return True, category, 201
        except Error as e:
            if "Duplicate entry" in str(e):
                return False, "Category with this name already exists", 400
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)

    @staticmethod
    def get_all():
      connection = get_connection()
      if not connection:
        return False, "Database connection failed", 500
      try:
         cursor = connection.cursor(dictionary=True)
   
         query = """
              SELECT 
            c.category_id,
            c.category_name,
            c.category_description,
            COUNT(p.product_id) AS product_count
        FROM categories c
        LEFT JOIN products p
            ON p.category_id = c.category_id
        GROUP BY c.category_id
        ORDER BY c.category_name
        """
         cursor.execute(query)
         categories = cursor.fetchall()

         cursor.close()
         return True, categories, 200

      except Error as e:
        return False, f"Database error: {str(e)}", 500
      finally:
        close_connection(connection)


    @staticmethod
    def get_by_id(category_id):
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM categories WHERE category_id = %s", (category_id,))
            category = cursor.fetchone()
            cursor.close()
            if not category:
                return False, "Category not found", 404
            return True, category, 200
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)

    @staticmethod
    def update(category_id, data):
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM categories WHERE category_id = %s", (category_id,))
            if not cursor.fetchone():
                cursor.close()
                return False, "Category not found", 404

            update_fields = []
            values = []
            allowed_fields = ['category_name', 'category_description']
            for field in allowed_fields:
                if field in data:
                    update_fields.append(f"{field} = %s")
                    values.append(data[field])
            if not update_fields:
                cursor.close()
                return False, "No valid fields to update", 400

            values.append(category_id)
            query = f"UPDATE categories SET {', '.join(update_fields)} WHERE category_id = %s"
            cursor.execute(query, values)
            connection.commit()
            cursor.execute("SELECT * FROM categories WHERE category_id = %s", (category_id,))
            category = cursor.fetchone()
            cursor.close()
            return True, category, 200
        except Error as e:
            if "Duplicate entry" in str(e):
                return False, "Category with this name already exists", 400
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)

    @staticmethod
    def delete(category_id):
        connection = get_connection()
        if not connection:
            return False, "Database connection failed", 500
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM categories WHERE category_id = %s", (category_id,))
            if not cursor.fetchone():
                cursor.close()
                return False, "Category not found", 404
            cursor.execute("DELETE FROM categories WHERE category_id = %s", (category_id,))
            connection.commit()
            cursor.close()
            return True, {"message": "Category deleted successfully"}, 200
        except Error as e:
            return False, f"Database error: {str(e)}", 500
        finally:
            close_connection(connection)
