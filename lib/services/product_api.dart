import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductApi {
  // PC localhost from Android emulator
  static const String baseUrl = "http://10.0.2.2:5000/api/products";

  static Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["products"]; // backend returns {"count": x, "products": [...]}
    } else {
      throw Exception("Failed to load products");
    }
  }

  static Future<void> deleteProduct(int id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
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
