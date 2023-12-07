import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    leading: Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
          child: Image.asset(
            'logo.png',
            width: 40.0,
            height: 40.0,
          ),
        ),
      ],
    ),
    title: Text(
      "Bibliz",
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
    ),
  );
}
