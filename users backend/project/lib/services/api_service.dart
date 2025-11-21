import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // adjust if your backend runs on a different port/address
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<bool> login(String username, String password) async {
    final uri = Uri.parse('$baseUrl/login');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    return res.statusCode == 200;
  }

  static Future<List<dynamic>> getUsers() async {
    final uri = Uri.parse('$baseUrl/users');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Failed to fetch users');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<bool> createUser(Map<String, dynamic> user) async {
    final uri = Uri.parse('$baseUrl/users');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }

  static Future<bool> updateUser(int id, Map<String, dynamic> user) async {
    final uri = Uri.parse('$baseUrl/users/$id');
    final res = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user),
    );
    return res.statusCode == 200;
  }

  static Future<bool> changeState(int id, bool isActive) async {
    final uri = Uri.parse('$baseUrl/users/$id/state');
    final res = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'is_active': isActive}),
    );
    return res.statusCode == 200;
  }

  static Future<bool> deleteUser(int id) async {
    final uri = Uri.parse('$baseUrl/users/$id');
    final res = await http.delete(uri);
    return res.statusCode == 200;
  }
}
