import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryApi {
  static const String baseUrl = "http://127.0.0.1:5000/api/categories/";

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }

  static Future<Map<String, dynamic>> getCategoryById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl$id"));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded["category"] ?? decoded;
    } else {
      throw Exception("Failed to load category");
    }
  }

  static Future<void> addCategory(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add category: ${response.body}");
    }
  }

  static Future<void> updateCategory(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update category: ${response.body}");
    }
  }

  static Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete category");
    }
  }
}
