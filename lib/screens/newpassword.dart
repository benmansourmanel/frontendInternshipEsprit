import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewPasswordScreen extends StatefulWidget {
  final String email;
  final String code;

  const NewPasswordScreen({
    Key? key,
    required this.email,
    required this.code,
  }) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final String apiUrl = 'http://localhost:5000/api/pwd'; // Replace with your backend URL

  Future<void> _resetPassword() async {
    final newPassword = _newPasswordController.text;

    if (newPassword.isEmpty || _confirmPasswordController.text != newPassword) {
      // Show an error message
      return;
    }

    final response = await http.post(
      Uri.parse('$apiUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.email,
        'code': widget.code,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/login'); // Navigate to login page
    } else {
      final responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] ?? 'Error updating password';
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/bg1.png', // Path to your background image
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Container(
            height: 400,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.3), // Adjust opacity for overlay
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                    children: [
                      Text(
                        "Reinitialize Password",
                        style: TextStyle(
                          fontSize: 28, // Adjust font size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Roboto', // Match font family
                        ),
                        textAlign: TextAlign.center, // Center text horizontally
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 50, // Adjust height for better visibility
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white)),
                        ),
                        child: TextFormField(
                          controller: _newPasswordController,
                          obscureText: _obscureText1,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter your new password',
                            hintStyle: const TextStyle(color: Colors.white70),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText1 ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText1 = !_obscureText1;
                                });
                              },
                            ),
                            fillColor: Colors.white,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 50, // Adjust height for better visibility
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white)),
                        ),
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureText2,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Confirm your new password',
                            hintStyle: const TextStyle(color: Colors.white70),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText2 ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText2 = !_obscureText2;
                                });
                              },
                            ),
                            fillColor: Colors.white,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: _resetPassword,
                        child: Container(
                          height: 50, // Adjust height for better visibility
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto', // Match font family
                              fontSize: 18, // Adjust font size
                            ),
                            textAlign: TextAlign.center, // Center text
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white, side: BorderSide(color: Colors.white),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Back to Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto', // Match font family
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

}
