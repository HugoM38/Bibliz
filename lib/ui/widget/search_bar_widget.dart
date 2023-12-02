import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  const SearchBarWidget({
    Key? key,
    required this.searchController,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: const InputDecoration(
        hintText: 'Rechercher un livre',
        suffixIcon: Icon(Icons.search),
      ),
      onChanged: (value) => onSearchChanged(value),
    );
  }
}
