import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for the backend API
  // Change this to your backend URL if different
  static const String baseUrl = 'http://127.0.0.1:5000';

  // Get headers for API requests
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // GET /pos/products - Fetch available products
  static Future<List<Map<String, dynamic>>> getPosProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pos/products'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['products'] ?? []);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // POST /pos/transactions - Create a new transaction
  static Future<Map<String, dynamic>> createTransaction({
    required int workerId,
    required double totalAmount,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pos/transactions'),
        headers: _headers,
        body: json.encode({
          'worker_id': workerId,
          'total_amount': totalAmount,
          'payment_method': paymentMethod,
          'items': items,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to create transaction');
      }
    } catch (e) {
      throw Exception('Error creating transaction: $e');
    }
  }

  // GET /api/transactions - Fetch transactions with optional filters
  static Future<Map<String, dynamic>> getTransactions({
    int page = 1,
    int limit = 10,
    String? search,
    String? date,
    String? paymentMethod,
    int? workerId,
  }) async {
    try {
      // Build query parameters
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (date != null && date.isNotEmpty) {
        queryParams['date'] = date;
      }
      if (paymentMethod != null && paymentMethod != 'All Methods') {
        queryParams['payment_method'] = paymentMethod;
      }
      if (workerId != null) {
        queryParams['worker_id'] = workerId.toString();
      }

      final uri = Uri.parse('$baseUrl/api/transactions').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }

  // GET /api/transactions/<id> - Fetch transaction details
  static Future<Map<String, dynamic>> getTransactionDetails(int transactionId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/transactions/$transactionId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to load transaction details');
      }
    } catch (e) {
      throw Exception('Error fetching transaction details: $e');
    }
  }

  // POST /api/transactions/<id>/return - Process transaction return
  static Future<Map<String, dynamic>> returnTransaction(int transactionId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/transactions/$transactionId/return'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to return transaction');
      }
    } catch (e) {
      throw Exception('Error returning transaction: $e');
    }
  }
}

