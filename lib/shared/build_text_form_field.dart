import 'package:flutter/material.dart';

Widget buildTextFormField(
    TextEditingController controller, String label, IconData icon,
    {int maxLines = 1, bool isNumber = false}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
    ),
    maxLines: maxLines,
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez entrer $label';
      }
      if (isNumber && int.tryParse(value) == null) {
        return 'Veuillez entrer un nombre valide pour $label';
      }
      return null;
    },
  );
}
