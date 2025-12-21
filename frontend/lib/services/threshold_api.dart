import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ThresholdApi {
  static const String baseUrl = ApiService.baseUrl;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Get all thresholds
  static Future<Map<String, dynamic>> getThresholds() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/thresholds/'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load thresholds: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching thresholds: $e');
    }
  }

  /// Create a new threshold
  static Future<Map<String, dynamic>> createThreshold({
    required String thresholdType,
    int? productId,
    String? categoryName,
    required int thresholdValue,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'threshold_type': thresholdType,
        'threshold_value': thresholdValue,
      };

      if (thresholdType == 'product' && productId != null) {
        body['product_id'] = productId;
      } else if (thresholdType == 'category' && categoryName != null) {
        body['category_name'] = categoryName;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/thresholds/'),
        headers: _headers,
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to create threshold');
      }
    } catch (e) {
      throw Exception('Error creating threshold: $e');
    }
  }

  /// Get a specific threshold by ID
  static Future<Map<String, dynamic>> getThresholdById(int thresholdId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/thresholds/$thresholdId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load threshold: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching threshold: $e');
    }
  }

  /// Update a threshold
  static Future<Map<String, dynamic>> updateThreshold({
    required int thresholdId,
    required int thresholdValue,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/thresholds/$thresholdId'),
        headers: _headers,
        body: json.encode({
          'threshold_value': thresholdValue,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to update threshold');
      }
    } catch (e) {
      throw Exception('Error updating threshold: $e');
    }
  }

  /// Delete a threshold
  static Future<Map<String, dynamic>> deleteThreshold(int thresholdId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/thresholds/$thresholdId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to delete threshold');
      }
    } catch (e) {
      throw Exception('Error deleting threshold: $e');
    }
  }

  /// Check if a category has a threshold
  static Future<Map<String, dynamic>> getCategoryThreshold(String categoryName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/thresholds/category/$categoryName'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to check category threshold: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error checking category threshold: $e');
    }
  }

  /// Apply category threshold to all products
  static Future<Map<String, dynamic>> applyCategoryThreshold({
    required String categoryName,
    required int thresholdValue,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/thresholds/apply-category'),
        headers: _headers,
        body: json.encode({
          'category_name': categoryName,
          'threshold_value': thresholdValue,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to apply category threshold');
      }
    } catch (e) {
      throw Exception('Error applying category threshold: $e');
    }
  }
}
