import 'dart:convert';
import 'package:http/http.dart' as http;

class BatchApi {
  static const String baseUrl = "http://127.0.0.1:5000/api";

  // Get all batches for a specific product
  static Future<List<Map<String, dynamic>>> getBatchesByProduct(int productId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/products/$productId/batches"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List batches = data["batches"] as List;

      return batches
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } else {
      throw Exception("Failed to load batches: ${response.body}");
    }
  }

  // Get all batches (admin view)
  static Future<List<Map<String, dynamic>>> getAllBatches() async {
    final response = await http.get(Uri.parse("$baseUrl/batches"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List batches = data["batches"] as List;

      return batches
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } else {
      throw Exception("Failed to load batches: ${response.body}");
    }
  }

  // Get a single batch by ID
  static Future<Map<String, dynamic>> getBatchById(int batchId) async {
    final response = await http.get(Uri.parse("$baseUrl/batches/$batchId"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data["batch"] as Map<String, dynamic>;
    } else {
      throw Exception("Failed to load batch: ${response.body}");
    }
  }

  // Create a new batch
  static Future<void> createBatch(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/batches"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to create batch: ${response.body}");
    }
  }

  // Update an existing batch
  static Future<void> updateBatch(int batchId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/batches/$batchId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update batch: ${response.body}");
    }
  }

  // Delete a batch
  static Future<void> deleteBatch(int batchId) async {
    final response = await http.delete(Uri.parse("$baseUrl/batches/$batchId"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete batch: ${response.body}");
    }
  }

  // Get expiring batches (within X days)
  static Future<List<Map<String, dynamic>>> getExpiringBatches({int days = 30}) async {
    final response = await http.get(
      Uri.parse("$baseUrl/batches/expiring?days=$days"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List batches = data["batches"] as List;

      return batches
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } else {
      throw Exception("Failed to load expiring batches: ${response.body}");
    }
  }

  // Get expired batches
  static Future<List<Map<String, dynamic>>> getExpiredBatches() async {
    final response = await http.get(Uri.parse("$baseUrl/batches/expired"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List batches = data["batches"] as List;

      return batches
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } else {
      throw Exception("Failed to load expired batches: ${response.body}");
    }
  }
}