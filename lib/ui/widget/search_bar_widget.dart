import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final String hintText;
  final Function(String) onSearchChanged;
  final List<String>? searchOptions;
  final TextEditingController? dropdownController;

  const SearchBarWidget({
    Key? key,
    required this.hintText,
    required this.searchController,
    required this.onSearchChanged,
    this.searchOptions,
    this.dropdownController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.primary,
                hintText: hintText,
                hintStyle:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                suffixIcon: const Icon(Icons.search),
                suffixIconColor: Theme.of(context).colorScheme.secondary),
            onChanged: onSearchChanged,
          ),
        ),
        getDropdown()
      ],
    );
  }

  Widget getDropdown() {
    if (searchOptions != null && dropdownController != null) {
      return DropdownButton<String>(
        value: dropdownController!.text.isEmpty
            ? searchOptions!.first
            : dropdownController!.text,
        onChanged: (String? newValue) {
          if (newValue != null) {
            dropdownController!.text = newValue;
            onSearchChanged(searchController.text);
          }
        },
        items: searchOptions!.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    } else {
      return Container();
    }
  }
}
