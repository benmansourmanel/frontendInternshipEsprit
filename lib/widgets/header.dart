import 'package:flutter/material.dart';

class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2, size.height * 2, 
      size.width, size.height
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2, size.height * 2, 
      size.width, size.height
    );
    path.lineTo(size.width, 0);
    path.close();

    // Draw the filled path
    canvas.drawPath(path, paint);

    // Draw the white border
    Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HedhahouwaAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  HedhahouwaAppBar({Key? key}) 
    : preferredSize = Size.fromHeight(200.0),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HalfCircleClipper(),
      child: CustomPaint(
        painter: HalfCirclePainter(),
        child: Container(
          height: preferredSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Teacher Space',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Hello Mr. John Doe 👋🏻',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              const SizedBox(height: 50),
              CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage('assets/avatar.jpg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
