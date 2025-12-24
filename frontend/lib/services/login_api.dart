import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginApi {
  static const String baseUrl = 'http://127.0.0.1:5000/api/users';

  /// Attempt login with username and password
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    try {
      // First, fetch all users to check username
      final response = await http.get(Uri.parse('$baseUrl'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final users = data['users'] as List;

        final user = users.firstWhere(
          (u) => u['username'] == username,
          orElse: () => null,
        );

        if (user == null) {
          return {'success': false, 'message': 'User does not exist'};
        }

        // Now check password by calling a dedicated route
        final passCheck = await http.post(
          Uri.parse('$baseUrl/login'), // you will create this backend route
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username, 'password': password}),
        );

        if (passCheck.statusCode == 200) {
          return {'success': true, 'user': user};
        } else {
          final error = jsonDecode(passCheck.body);
          return {
            'success': false,
            'message': error['error'] ?? 'Wrong password'
          };
        }
      } else {
        return {'success': false, 'message': 'Failed to fetch users'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
