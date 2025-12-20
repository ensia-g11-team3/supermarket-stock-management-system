import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApi {
  static const String baseUrl = "http://127.0.0.1:5000/api/users";

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> users = data["users"] as List<dynamic>;

      return users.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }

  static Future<Map<String, dynamic>> getUserById(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to load User");
    }

    return jsonDecode(response.body);
  }

  static Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete user");
    }
  }

  static Future<void> addUser(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add user: ${response.body}");
    }
  }

  static Future<void> updateUser(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update user: ${response.body}");
    }
  }
}
