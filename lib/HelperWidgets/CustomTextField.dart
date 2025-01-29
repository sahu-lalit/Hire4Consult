import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for inputFormatters

TextField customTextField({
  String? hintText,
  TextEditingController? controller,
  bool? obscureText,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters, 
  int? maxLines,
}) {
  return TextField(
    keyboardType: keyboardType ?? TextInputType.text,
    obscureText: obscureText ?? false,
    controller: controller,
    inputFormatters: inputFormatters, // Apply inputFormatters here
      maxLines: maxLines ?? 1,
    decoration: InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff212E50)),
        borderRadius: BorderRadius.circular(50),
      ),
      hintText: hintText ?? '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      contentPadding:
          EdgeInsets.only(left: 30.0, right: 30.0, top: 20, bottom: 20),
    ),
    cursorHeight: 20,
    style: TextStyle(), // Default text style
  );
}
