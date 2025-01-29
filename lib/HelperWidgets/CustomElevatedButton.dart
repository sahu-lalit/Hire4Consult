import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ElevatedButton customElevatedButton(
    {required VoidCallback? onPress, String? buttonText, Color? backgroundColor, double? height}) {
  return ElevatedButton(
    onPressed: onPress,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: height ?? 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    child: Text(buttonText ?? '',
        style: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1)),
  );
}
