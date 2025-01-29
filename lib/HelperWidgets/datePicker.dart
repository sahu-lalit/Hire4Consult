import 'package:flutter/material.dart';

Widget datePicker({
  required String labelText,
  required String hintText,
  required TextEditingController controller,
  bool isDatePicker = false,
  required BuildContext context,
}) {
  return TextFormField(
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
    style: TextStyle(),
    controller: controller,
    autofocus: false,
    autofillHints: isDatePicker ? null : [AutofillHints.name],
    obscureText: false,
    readOnly: isDatePicker, // Disable manual input for date fields
    onTap: isDatePicker
        ? () async {
            // Show date picker when the field is tapped
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Color(0xFFCE2029), // Header background color
                      onPrimary: Colors.white, // Header text color
                      onSurface: Colors.black, // Body text color
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (selectedDate != null) {
              // Format and set the selected date in the TextEditingController
              controller.text = "${selectedDate.toLocal()}".split(' ')[0];
            }
          }
        : null,

    cursorColor: Color(0xFFCE2029),
  );
}
