import 'dart:convert';
import 'package:http/http.dart' as http;

class ReclamationService {
  Future<List<Map<String, dynamic>>> getReclamationsByEnseignant(String token) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/reclamations'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load reclamations');
    }
  }
}
