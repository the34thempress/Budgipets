import 'package:flutter/material.dart';

class LogButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6B3E1D),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: const Text(
        "Log",
        style: TextStyle(
          fontFamily: "Modak",
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
