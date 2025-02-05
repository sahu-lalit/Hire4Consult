import 'package:flutter/material.dart';

class CustomSearchableDropdown extends StatefulWidget {
  final List<String> items;
  final String? hintText;
  final TextEditingController? controller;
  final void Function(String?)? onChanged;

  const CustomSearchableDropdown({
    super.key,
    required this.items,
    this.hintText,
    this.controller,
    this.onChanged,
  });

  @override
  State<CustomSearchableDropdown> createState() => _CustomSearchableDropdownState();
}

class _CustomSearchableDropdownState extends State<CustomSearchableDropdown> {
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void _openSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                            filteredItems = widget.items.where((item) =>
                                item.toLowerCase().contains(searchQuery)).toList();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(filteredItems[index]),
                            onTap: () {
                              widget.controller?.text = filteredItems[index];
                              widget.onChanged?.call(filteredItems[index]);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff212E50)),
          borderRadius: BorderRadius.circular(50),
        ),
        hintText: widget.hintText ?? '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      onTap: () => _openSearchDialog(context),
    );
  }
}