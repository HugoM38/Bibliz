import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> items;
  final String labelText;
  final IconData icon;
  final Function(String)? onItemSelected; // Ajout d'un callback

  const CustomDropdownFormField({
    Key? key,
    required this.controller,
    required this.items,
    required this.labelText,
    required this.icon,
    this.onItemSelected, // Initialisation du callback
  }) : super(key: key);

  @override
  _CustomDropdownFormFieldState createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(_overlayEntry!);
      } else {
        _overlayEntry?.remove();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5.0,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: widget.items.where((item) {
              // Si le champ est vide, afficher tous les éléments.
              // Sinon, filtrer en fonction de la saisie.
              return widget.controller.text.isEmpty ||
                  item
                      .toLowerCase()
                      .contains(widget.controller.text.toLowerCase());
            }).map<Widget>((String item) {
              return ListTile(
                title: Text(item),
                onTap: () {
                  print("test");
                  _overlayEntry?.remove();
                  widget.controller.text = item; // Mise à jour du contrôleur
                  widget.onItemSelected?.call(item); // Utiliser le callback
                  _focusNode.unfocus();
                  setState(() {}); // Rebuild pour mettre à jour l'affichage
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: Icon(widget.icon),
        suffixIcon: Icon(Icons.arrow_drop_down),
      ),
      onChanged: (value) {
        _overlayEntry?.remove();
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(_overlayEntry!);
      },
    );
  }
}
