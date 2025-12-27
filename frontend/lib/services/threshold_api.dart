import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ThresholdApi {
  static const String baseUrl = ApiService.baseUrl;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Get all thresholds (products with thresholds set)
  static Future<Map<String, dynamic>> getThresholds() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/products/products'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = List<Map<String, dynamic>>.from(data['products'] ?? []);
        
        // Transform products into threshold format
        final thresholds = products.map((product) {
          return {
            'threshold_id': product['product_id'],
            'threshold_type': 'product',
            'entity_name': product['name'],
            'product_id': product['product_id'],
            'category_name': product['category'],
            'threshold_value': product['product_threshold'],
            'created_at': product['created_at'],
          };
        }).toList();

        return {'thresholds': thresholds};
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching thresholds: $e');
    }
  }

  /// Create a new threshold (update product's threshold)
  static Future<Map<String, dynamic>> createThreshold({
    required String thresholdType,
    int? productId,
    String? categoryName,
    required int thresholdValue,
  }) async {
    try {
      print('Creating threshold: type=$thresholdType, productId=$productId, categoryName=$categoryName, value=$thresholdValue');
      
      if (thresholdType == 'product' && productId != null) {
        // Update single product's threshold
        print('Updating product $productId with threshold $thresholdValue');
        final response = await http.put(
          Uri.parse('$baseUrl/api/products/products/$productId'),
          headers: _headers,
          body: json.encode({
            'product_threshold': thresholdValue,
          }),
        );

        print('Product update response: ${response.statusCode}');
        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          final errorData = json.decode(response.body);
          throw Exception(errorData['error'] ?? 'Failed to set threshold');
        }
      } else if (thresholdType == 'category' && categoryName != null) {
        // Apply threshold to all products in category
        print('Applying category threshold for $categoryName');
        final result = await applyCategoryThreshold(
          categoryName: categoryName,
          thresholdValue: thresholdValue,
        );
        print('Category threshold result: $result');
        return result;
      } else {
        throw Exception('Invalid threshold type or missing parameters');
      }
    } catch (e) {
      print('Error in createThreshold: $e');
      throw Exception('Error creating threshold: $e');
    }
  }

  /// Get a specific threshold by product ID
  static Future<Map<String, dynamic>> getThresholdById(int productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/products/products/$productId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final product = data['product'];
        
        return {
          'threshold': {
            'threshold_id': product['product_id'],
            'threshold_type': 'product',
            'entity_name': product['name'],
            'product_id': product['product_id'],
            'category_name': product['category'],
            'threshold_value': product['product_threshold'],
            'created_at': product['created_at'],
          }
        };
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching threshold: $e');
    }
  }

  /// Update a threshold (update product's threshold)
  static Future<Map<String, dynamic>> updateThreshold({
    required int thresholdId,
    required int thresholdValue,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/products/products/$thresholdId'),
        headers: _headers,
        body: json.encode({
          'product_threshold': thresholdValue,
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

  /// Delete a threshold (set product's threshold to null)
  static Future<Map<String, dynamic>> deleteThreshold(int productId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/products/products/$productId'),
        headers: _headers,
        body: json.encode({
          'product_threshold': null,
        }),
      );

      if (response.statusCode == 200) {
        return {'message': 'Threshold deleted successfully'};
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to delete threshold');
      }
    } catch (e) {
      throw Exception('Error deleting threshold: $e');
    }
  }

  /// Check if a category has products with thresholds
  static Future<Map<String, dynamic>> getCategoryThreshold(String categoryName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/products/products'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = List<Map<String, dynamic>>.from(data['products'] ?? []);
        
        // Filter products by category
        final categoryProducts = products.where((p) => p['category'] == categoryName).toList();
        
        if (categoryProducts.isEmpty) {
          return {'exists': false};
        }

        // Check if any products have thresholds
        final productsWithThresholds = categoryProducts
            .where((p) => p['product_threshold'] != null)
            .toList();

        if (productsWithThresholds.isEmpty) {
          return {'exists': false};
        }

        // Return the most common threshold value
        final thresholdCounts = <int, int>{};
        for (var product in productsWithThresholds) {
          final threshold = product['product_threshold'] as int;
          thresholdCounts[threshold] = (thresholdCounts[threshold] ?? 0) + 1;
        }

        final mostCommonThreshold = thresholdCounts.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;

        return {
          'exists': true,
          'threshold': {
            'threshold_value': mostCommonThreshold,
            'product_count': productsWithThresholds.length,
          }
        };
      } else {
        throw Exception('Failed to check category threshold: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error checking category threshold: $e');
    }
  }

  /// Apply category threshold to all products in a category
  static Future<Map<String, dynamic>> applyCategoryThreshold({
    required String categoryName,
    required int thresholdValue,
  }) async {
    try {
      print('Applying category threshold: category=$categoryName, value=$thresholdValue');
      
      // First, get all products in the category
      final response = await http.get(
        Uri.parse('$baseUrl/api/products/products'),
        headers: _headers,
      );

      print('Fetched products, status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch products');
      }

      final data = json.decode(response.body);
      final products = List<Map<String, dynamic>>.from(data['products'] ?? []);
      
      print('Total products: ${products.length}');
      
      // Filter products by category
      final categoryProducts = products
          .where((p) => p['category'] == categoryName)
          .toList();

      print('Products in category "$categoryName": ${categoryProducts.length}');
      
      if (categoryProducts.isEmpty) {
        throw Exception('No products found in category: $categoryName');
      }

      // Update threshold for each product
      int successCount = 0;
      int failCount = 0;

      for (var product in categoryProducts) {
        try {
          print('Updating product ${product['product_id']} (${product['name']})');
          final updateResponse = await http.put(
            Uri.parse('$baseUrl/api/products/products/${product['product_id']}'),
            headers: _headers,
            body: json.encode({
              'product_threshold': thresholdValue,
            }),
          );

          if (updateResponse.statusCode == 200) {
            successCount++;
            print('  ✓ Success');
          } else {
            failCount++;
            print('  ✗ Failed: ${updateResponse.statusCode}');
          }
        } catch (e) {
          failCount++;
          print('  ✗ Error: $e');
        }
      }

      print('Category threshold applied: $successCount success, $failCount failed');
      
      return {
        'message': 'Category threshold applied',
        'category': categoryName,
        'threshold_value': thresholdValue,
        'products_updated': successCount,
        'products_failed': failCount,
        'total_products': categoryProducts.length,
      };
    } catch (e) {
      print('Error in applyCategoryThreshold: $e');
      throw Exception('Error applying category threshold: $e');
    }
  }
}
