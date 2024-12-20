import 'package:flutter/material.dart';
import 'package:snow_login/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<Color?> _spinnerColorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Define animations
    _logoScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _spinnerColorAnimation = ColorTween(begin: Colors.red, end: Colors.blue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 4), () {}); 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splachBack.jpg'), // Path to your background image
            fit: BoxFit.cover, // Cover the whole screen
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated CircularProgressIndicator
              Positioned(
                child: Container(
                  width: 200,
                  height: 200, 
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CircularProgressIndicator(
                        strokeWidth: 25.0,
                        valueColor: AlwaysStoppedAnimation<Color>(_spinnerColorAnimation.value ?? Colors.red),
                      );
                    },
                  ),
                ),
              ),
              // Animated logo container
              ScaleTransition(
                scale: _logoScaleAnimation,
                child: Container(
                  width: 200,
                  height: 200, 
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, 
                    border: Border.all(color: Colors.grey, width: 5.0), 
                  ),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent, 
                      radius: 90, 
                      child: Image.asset(
                        'assets/logoEsprit copy.png', 
                        width: 150, // Width of the logo
                        height: 150, // Height of the logo
                        fit: BoxFit.contain, // Ensure the logo fits well within the CircleAvatar
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
