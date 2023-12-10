import 'package:bibliz/ui/widget/custom_dropdown_form_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum FieldType { text, dropdown, searchableDropdown, date }

Widget buildTextFormField(
  BuildContext context,
  TextEditingController controller,
  String label,
  IconData icon, {
  int maxLines = 1,
  bool isNumber = false,
  FieldType fieldType = FieldType.text,
  List<String>? dropdownItems,
  DateTime? initialDate,
  Function(String)? onItemSelected,
}) {
  if (fieldType == FieldType.text) {
    return TextFormField(
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      cursorColor: Theme.of(context).colorScheme.secondary,
      controller: controller,
      decoration: InputDecoration(
        prefixIconColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
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
  } else if (fieldType == FieldType.dropdown && dropdownItems != null) {
    return DropdownButtonFormField<String>(
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      dropdownColor: Theme.of(context).colorScheme.primary,
      value: dropdownItems.isNotEmpty ? dropdownItems.first : null,
      elevation: 8,
      icon: Icon(Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.secondary),
      decoration: InputDecoration(
        prefixIconColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary,
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
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
  } else if (fieldType == FieldType.searchableDropdown &&
      dropdownItems != null) {
    return CustomDropdownFormField(
      controller: controller,
      items: dropdownItems,
      labelText: label,
      icon: icon,
      onItemSelected: onItemSelected,
    );
  } else if (fieldType == FieldType.date) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      cursorColor: Theme.of(context).colorScheme.secondary,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.secondary,),
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

  return Container();
}
