import 'package:flutter/material.dart';
import 'package:reals/utils/dimensions.dart';

class TextInputBorder extends StatelessWidget {
  final String hint;
  final double leftPadding;
  final double topPadding;
  final double rightPadding;
  final double bottomPadding;

  const TextInputBorder({
    Key? key,
    required this.hint,
    this.leftPadding = 0,
    this.topPadding = 0,
    this.rightPadding = 0,
    this.bottomPadding = 0,
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
              child: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: hint,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}