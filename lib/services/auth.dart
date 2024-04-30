import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseApi = 'http://localhost:3000/api/user';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseApi/login');
    final response = await http.post(
      url,
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      // Successful login
      final responseData = json.decode(response.body);
      return {'success': true, 'data': responseData};
    } else {
      // Login failed
      final errorMessage = json.decode(response.body)['error'];
      return {'success': false, 'message': errorMessage};
    }
  }
}
