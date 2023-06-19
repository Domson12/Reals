import 'package:flutter/cupertino.dart';

class TeardropClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, size.height * 0.5);
    path.arcToPoint(
      Offset(size.width, size.height * 0.5),
      radius: const Radius.circular(10),
      clockwise: false,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.5, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class TeardropPainter extends CustomPainter {
  final List<Color> gradientColors;

  TeardropPainter({required this.gradientColors});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.lineTo(size.width, size.height * 0.5);
    path.arcToPoint(
      Offset(size.width, size.height * 0.5),
      radius: Radius.circular(10),
      clockwise: false,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.5, size.height);
    path.close();

    final paint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(
          Rect.fromPoints(Offset.zero, Offset(size.width, size.height)));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TeardropPainter oldDelegate) {
    return oldDelegate.gradientColors != gradientColors;
  }
}
