import 'package:flutter/material.dart';

import '../utils/global_variables.dart';

class TextInputFramed extends StatelessWidget {
  final String hint;
  final double leftPadding;
  final double topPadding;
  final double rightPadding;
  final double bottomPadding;
  final TextEditingController controller;
  final bool obscureText;

  const TextInputFramed({
    Key? key,
    required this.hint,
    this.leftPadding = 0,
    this.topPadding = 0,
    this.rightPadding = 0,
    this.bottomPadding = 0,
    this.obscureText = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > webScreenSize;

        return Container(
          padding: EdgeInsets.only(
            left: leftPadding,
            top: topPadding,
            right: rightPadding,
            bottom: bottomPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: isWeb
                  ? const BoxConstraints(maxWidth: 300)
                  : const BoxConstraints(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF8A2BE2), // Purple color
                      Color(0xFFFF69B4), // Pink color
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                child: TextField(
                  obscureText: obscureText,
                  controller: controller,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: hint,
                    hintStyle: const TextStyle(color: Colors.white),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
