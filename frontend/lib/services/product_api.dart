import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductApi {
  //DONE by Leryeme
  // PC localhost
  static const String baseUrl = "http://127.0.0.1:5000/api/products/products";

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> products = data["products"] as List<dynamic>;

      return products.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  static Future<Map<String, dynamic>> getProductById(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to load product");
    }

    return jsonDecode(response.body);
  }

  static Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete product");
    }
  }

  static Future<void> addProduct(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add product: ${response.body}");
    }
  }

  static Future<void> updateProduct(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update product: ${response.body}");
    }
  }
}
