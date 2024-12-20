import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snow_login/screens/login_screen.dart';
import 'package:snow_login/screens/forgetpassword.dart';
import 'package:snow_login/screens/verifyCodefp.dart';
import 'package:snow_login/screens/newpassword.dart'; // Import only once from this location
import 'package:snow_login/screens/homepage.dart';
import 'package:snow_login/screens/reclamations.dart';
import 'package:snow_login/screens/splash_screen.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Use the SplashScreen as the initial screen
      routes: {
        '/login': (context) => const LoginScreen(),
        '/forgetpassword': (context) => const ForgetPasswordScreen(),
        '/verifyOTP': (context) => const VerifyCodefpScreen(),
'/changepwd': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return NewPasswordScreen(
            email: args['email']!,
            code: args['code']!,
          );
        },        '/homepage': (context) => const HomePage(),
        '/Reclamations': (context) => const ReclamationsScreen(),
      },
    );
  }
}
