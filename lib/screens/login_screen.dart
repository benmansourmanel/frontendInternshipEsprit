import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:snow_login/utils/animations.dart';
import '../data/bg_data.dart';
import '../utils/text_utils.dart';
import 'homepage.dart';
import '../api/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  bool showOption = false;
  bool _isPressed = false;
  String? _emailError;
  String? _passwordError;
  String? _loginError;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Email validation using regular expression
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  // Login logic
  Future<void> _login() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _loginError = null;
    });

    // Validate email format
    if (!_isValidEmail(_emailController.text)) {
      setState(() {
        _emailError = 'Invalid email format';
      });
      return;
    }

    // Call the login function
    final response = await AuthService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (response['token'] != null) {
      await AuthService.saveToken(response['token']); // Save the token

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Handle error, show a message
      setState(() {
        _loginError = response['message'] ?? 'Login failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 49,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
                child: showOption
                    ? ShowUpAnimation(
                        delay: 100,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: bgList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: selectedIndex == index
                                      ? Colors.white
                                      : Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          AssetImage(bgList[index]),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    : const SizedBox()),
            const SizedBox(
              width: 20,
            ),
            showOption
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = false;
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ))
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = true;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(bgList[selectedIndex]),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgList[selectedIndex]),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Animated triangles in the background
          AnimatedTriangles(),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Image.asset(
                'assets/logoEsprit copy.png',
                height: 60,
              ),
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
                color: Colors.black.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Center(
                          child: Column(
                            children: [
                              TextUtil(
                                text: "Sign In",
                                weight: true,
                                size: 30,
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const Spacer(),
                        TextUtil(text: "Email"),
                        Container(
                          height: 35,
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.white))),
                          child: TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              hintStyle: const TextStyle(color: Colors.white70),
                              suffixIcon: const Icon(Icons.mail, color: Colors.white),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              errorText: _emailError, // Show email error
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextUtil(text: "Password"),
                        Container(
                          height: 35,
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.white))),
                          child: TextFormField(
                            controller: _passwordController,
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: const TextStyle(color: Colors.white70),
                              suffixIcon: const Icon(Icons.lock, color: Colors.white),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              errorText: _passwordError, // Show password error
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (_loginError != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              _loginError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        Row(
                          children: [
                            const SizedBox(width: 10,),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/forgetpassword');
                                },
                                child: TextUtil(
                                  text: "* Forget Your Password ?",
                                  size: 10,
                                  weight: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        AnimatedScale(
                          scale: _isPressed ? 0.95 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isPressed = true;
                              });
                              Future.delayed(const Duration(milliseconds: 100), _login);
                            },
                            child: Container(
                              height: 35,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
