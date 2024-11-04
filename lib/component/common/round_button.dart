import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final String size;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const RoundButton({
    Key? key,
    required this.text,
    this.size = 'medium',
    this.backgroundColor = Colors.transparent,
    this.onPressed = _defaultOnPressed,
  });

  static void _defaultOnPressed() {}

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: this.backgroundColor,
      ),
      child: Text(this.text),
    );
  }
}
