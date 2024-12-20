import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class AuthService {
  static const String _baseUrl = 'http://localhost:5000/api/auth'; // Replace with your actual backend URL

  // Login method
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return {'message': 'User does not exist'};
    } else {
      return {'message': 'Login failed'};
    }
  }

  // Save token to SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print('Token saved: $token');
  }

  // Retrieve token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      print('Error: No token found or token is empty');
    } else {
      print('Token retrieved: $token');
    }
    return token;
  }

  // Logout method
  static Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null && token.isNotEmpty) {
        final response = await http.post(
          Uri.parse('$_baseUrl/logout'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token', // Use token for authentication if required
          },
        );

        if (response.statusCode == 200) {
          await prefs.remove('auth_token'); // Clear token
          print('Logged out successfully');

          // Navigate to the login screen after successful logout
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          print('Logout failed: ${response.body}');
        }
      } else {
        print('No token found to logout');
      }
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
