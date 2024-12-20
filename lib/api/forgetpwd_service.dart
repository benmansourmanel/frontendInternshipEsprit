import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgetPwdService {
  final String _baseUrl = 'http://localhost:5000/api/pwd'; // Adjust the base URL as needed

  Future<void> requestPasswordReset(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/request-password-reset'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to request password reset');
    }
  }
}
