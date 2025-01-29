import 'package:flutter/material.dart';

DropdownButtonFormField<String> customDropdown({
  required List<String> items,
  String? hintText,
  TextEditingController? controller,
  void Function(String?)? onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: controller?.text.isNotEmpty == true ? controller?.text : null,
    items: items
        .map((String value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList(),
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
          EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
    ),
    onChanged: (value) {
      if (controller != null) {
        controller.text = value ?? '';
      }
      if (onChanged != null) {
        onChanged(value);
      }
    },
    style: TextStyle(), // Default text style
  );
}
