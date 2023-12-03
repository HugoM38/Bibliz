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
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary,
          hintText: 'Rechercher un livre',
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
          suffixIcon: const Icon(Icons.search),
          suffixIconColor: Theme.of(context).colorScheme.secondary),
      onChanged: (value) => onSearchChanged(value),
    );
  }
}
