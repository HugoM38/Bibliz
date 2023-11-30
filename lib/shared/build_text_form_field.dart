import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum FieldType { text, dropdown, date }

Widget buildTextFormField(BuildContext context,
    TextEditingController controller, String label, IconData icon,
    {int maxLines = 1,
    bool isNumber = false,
    FieldType fieldType = FieldType.text,
    List<String>? dropdownItems,
    DateTime? initialDate}) {
  // Gestion de la saisie de texte
  if (fieldType == FieldType.text) {
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

  // Gestion du spinner (dropdown)
  else if (fieldType == FieldType.dropdown && dropdownItems != null) {
    return DropdownButtonFormField<String>(
      value: dropdownItems.isNotEmpty ? dropdownItems.first : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        controller.text = newValue ?? '';
      },
    );
  }

  // Gestion de la saisie de date
  else if (fieldType == FieldType.date) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2025),
        );
        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          controller.text = formattedDate;
        }
      },
    );
  }

  // Retourne un widget vide si le type n'est pas géré
  return Container();
}
