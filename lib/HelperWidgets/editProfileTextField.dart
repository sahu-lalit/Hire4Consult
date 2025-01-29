import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for inputFormatters

TextField editProfileTextField({
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
      // prefixIcon: Icon(Icons.search, color: Colors.black, size: 20),
      hintText: hintText ?? '',
      hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
      filled: false, // No background fill
      contentPadding: EdgeInsets.zero, // Remove vertical padding
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
    style: TextStyle(fontSize: 13, color: Colors.black),
    cursorHeight: 18,
  );
}
