import 'package:flutter/material.dart';

ElevatedButton customTextFieldLikeButton({
  required String label,
  required VoidCallback onPressed,
  Color borderColor = const Color(0xff212E50),
  double borderRadius = 50.0,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
    vertical: 25.0,
    horizontal: 30.0,
  ),
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor),
      ),
      elevation: 0.0,
      padding: padding,
      backgroundColor: Colors.white, // Default background color
      foregroundColor: borderColor, // Text color
      minimumSize: const Size(double.infinity, 0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    ),
  );
}
