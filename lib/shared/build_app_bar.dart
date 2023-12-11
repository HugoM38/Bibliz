import 'package:flutter/material.dart';

/*
    Fonction permettant de générer une l'appbar sur chaque page
*/
AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    title: Text(
      "Bibliz",
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
    ),
  );
}
