import 'package:flutter/material.dart';

/// Multi-select dropdown styled like your original `customDropdown`.
Widget customMultiSelectDropdown({
  required BuildContext context,
  required List<String> items,
  String? hintText,
  required TextEditingController controller,
  Color borderColor = const Color(0xff212E50),
  void Function(List<String>)? onSelectionChanged,
}) {
  return GestureDetector(
    onTap: () async {
      // Get previously selected values dynamically from the controller
      List<String> preSelected = controller.text
          .split(',')
          .map((e) => e.trim())
          .where((element) => element.isNotEmpty)
          .toList();

      // Show multi-select dialog
      final List<String>? selectedValues = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelectDialog(
            items: items,
            selectedValues: preSelected, // Pass dynamically fetched values
            title: "Select Options",
            borderColor: borderColor,
          );
        },
      );

      // Update controller with selected values
      if (selectedValues != null) {
        controller.text = selectedValues.join(', ');
        if (onSelectionChanged != null) {
          onSelectionChanged(selectedValues);
        }
      }
    },
    child: AbsorbPointer(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(50),
          ),
          hintText: hintText ?? 'Select options',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        ),
        style: TextStyle(),
        cursorColor: borderColor,
      ),
    ),
  );
}

/// Multi-select dialog widget
class MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> selectedValues;
  final String title;
  final Color borderColor;

  MultiSelectDialog({
    required this.items,
    required this.selectedValues,
    required this.title,
    required this.borderColor,
  });

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.selectedValues); // Initialize with pre-selected values
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.borderColor,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedValues.contains(item),
                    title: Text(item),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedValues.add(item);
                        } else {
                          _selectedValues.remove(item);
                        }
                      });
                    },
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: TextStyle(color: widget.borderColor),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _selectedValues),
          child: Text(
            "Save",
            style: TextStyle(color: widget.borderColor),
          ),
        ),
      ],
    );
  }
}
