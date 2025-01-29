import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

OutlinedButton customOutlineButton(
    {required VoidCallback? onPress, required String buttonText}) {
  return OutlinedButton(
    onPressed: onPress,
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.hovered)) {
          return Color(0xff212E50);
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.hovered)) {
          return Colors.white;
        }
        return Color(0xff212E50);
      }),
    ),
    child: Text(buttonText,
        style: GoogleFonts.quicksand(
            fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
  );
}
