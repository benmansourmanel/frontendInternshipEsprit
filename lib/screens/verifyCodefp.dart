import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/bg_data.dart';
import '../utils/text_utils.dart';
import '../widgets/toolbar.dart';

class VerifyCodefpScreen extends StatefulWidget {
  const VerifyCodefpScreen({super.key});

  @override
  State<VerifyCodefpScreen> createState() => _VerifyCodefpScreenState();
}

class _VerifyCodefpScreenState extends State<VerifyCodefpScreen> {
  int selectedIndex = 0;
  final List<TextEditingController> _otpControllers = List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(5, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _otpControllers.asMap().forEach((index, controller) {
      controller.addListener(() {
        String value = controller.text;
        if (value.length == 1) {
          _focusNextField(index);
        } else if (value.isEmpty) {
          _focusPreviousField(index);
        }
      });
    });
  }

  void _focusNextField(int index) {
    if (index < _otpControllers.length - 1) {
      FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
    }
  }

  void _focusPreviousField(int index) {
    if (index > 0) {
      FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
    }
  }

  String getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> verifyCode() async {
    setState(() {
      _isLoading = true;
    });

    final code = getOtpCode();
    final String email = ModalRoute.of(context)?.settings.arguments as String? ?? 'No email provided';

    final response = await http.post(
      Uri.parse('http://localhost:5000/api/pwd/confirm-otp'), // Replace with your backend URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
Navigator.pushNamed(
  context,
  '/changepwd',
  arguments: {
    'email': email, // replace with actual email value
    'code': code, // replace with actual OTP code value
  },
);
    } else {
      final responseData = jsonDecode(response.body);
      _showErrorDialog(responseData['message'] ?? 'Code verification failed');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              height: 450,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        TextUtil(
                          text: "Code Verification",
                          weight: true,
                          size: 30,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return Flexible(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                width: 45,
                                child: TextFormField(
                                  controller: _otpControllers[index],
                                  focusNode: _otpFocusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontSize: 24),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.red,
                                    hintText: '_',
                                    hintStyle: TextStyle(color: Colors.white70),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    counterText: '',
                                  ),
                                  maxLength: 1,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      _focusNextField(index);
                                    }
                                  },
                                  onEditingComplete: () {
                                    if (_otpControllers[index].text.isEmpty) {
                                      _focusPreviousField(index);
                                    }
                                  },
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 50),
                        GestureDetector(
                          onTap: _isLoading ? null : verifyCode,
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : TextUtil(
                                    text: "Confirm",
                                    color: Colors.black,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextUtil(
                          text: "Didn't receive your OTP code?",
                          size: 12,
                          weight: true,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            // Add functionality for resending code
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: TextUtil(
                              text: "Resend Code",
                              color: Colors.white,
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
          ),
        ],
      ),
    );
  }
}

class AnimatedTriangles extends StatefulWidget {
  @override
  _AnimatedTrianglesState createState() => _AnimatedTrianglesState();
}

class _AnimatedTrianglesState extends State<AnimatedTriangles> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: -200 * _animation.value,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 200),
            painter: TrianglePainter(_animation.value),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class TrianglePainter extends CustomPainter {
  final double animationValue;

  TrianglePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(size.width / 2, size.height * animationValue)
      ..lineTo(size.width * (animationValue + 0.5), size.height)
      ..lineTo(size.width * (0.5 - animationValue), size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
