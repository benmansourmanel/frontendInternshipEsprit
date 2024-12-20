import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/auth_service.dart';

class CahierClasseService {
  final String baseUrl;

  CahierClasseService({required this.baseUrl});

  Future<List<dynamic>> getCahierClasses() async {
    print('Fetching Cahier de Classe data...');

    // Retrieve token from SharedPreferences or AuthService
    String? token = await AuthService.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/cahierClasse'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Error fetching data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception caught: $e');
      return [];
    }
  }

  Future<void> createCahierClasse({
    required String date,
    required String contenu,
    required String horaireSeance,
    required String titreSeance,
    String? remarque,
    required String moduleId,
    required String classeId,
    required String semestre,
    String? userId,
  }) async {
    String? token = await AuthService.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$baseUrl/api/cahierClasse');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'date': date,
        'contenu': contenu,
        'horaire_seance': horaireSeance,
        'titre_seance': titreSeance,
        'remarque': remarque,
        'module': moduleId,
        'classe': classeId,
        'semestre': semestre,
        'user': userId,
      }),
    );

    if (response.statusCode == 201) {
      print('CahierClasse created successfully');
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
    }
  }
}
