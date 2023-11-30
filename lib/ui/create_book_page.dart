import 'dart:typed_data';

import 'package:bibliz/database/books/book.dart';
import 'package:bibliz/database/books/books_query.dart';
import 'package:bibliz/shared/build_text_form_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateBookPage extends StatefulWidget {
  const CreateBookPage({super.key});

  @override
  State<CreateBookPage> createState() => _CreateBookPageState();
}

class _CreateBookPageState extends State<CreateBookPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  Book? newBook;
  List<String> statusOptions = [
    'Disponible',
    'Emprunté',
    'En réparation',
    'Perdu'
  ];
  List<String> conditionOptions = ['Neuf', 'Bon', 'Usé', 'Endommagé'];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    // Dispose des contrôleurs quand la page est détruite
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _publisherController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    _summaryController.dispose();
    _languageController.dispose();
    _statusController.dispose();
    _conditionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Méthode pour choisir une image
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      // Gérer l'erreur
      print("Erreur lors de la sélection de l'image: $e");
    }
  }

  Future<String?> uploadImage(Uint8List imageBytes, String fileName) async {
    try {
      // Créer une référence au chemin où l'image sera stockée
      final ref = FirebaseStorage.instance.ref().child('images/$fileName');

      // Télécharger l'image
      final result = await ref.putData(imageBytes);

      // Retourner l'URL de l'image téléchargée
      return await result.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _createBook() async {
    String? imageUrl;
    if (_imageBytes != null) {
      imageUrl = await uploadImage(_imageBytes!, 'nom_de_l_image');
    }

    Book newBook = Book(
      title: _titleController.text,
      author: _authorController.text,
      isbn: _isbnController.text,
      publisher: _publisherController.text,
      publicationYear: int.tryParse(_yearController.text) ?? 0,
      genre: _genreController.text,
      summary: _summaryController.text,
      language: _languageController.text,
      status: _statusController.text,
      condition: _conditionController.text,
      location: _locationController.text,
      imageUrl: imageUrl,
    );
    // Utilisez BookQuery pour enregistrer le livre
    BookQuery().addBook(newBook).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Livre ajouté avec succès!'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'ajout du livre: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Bibliz"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text("Créer un nouveau livre",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    buildTextFormField(
                        context, _titleController, 'Titre', Icons.book),
                    buildTextFormField(
                        context, _authorController, 'Auteur', Icons.person),
                    buildTextFormField(
                        context, _isbnController, 'ISBN', Icons.code),
                    buildTextFormField(context, _publisherController, 'Éditeur',
                        Icons.business),
                    buildTextFormField(context, _yearController,
                        'Année de publication', Icons.calendar_today,
                        fieldType: FieldType
                            .date // Utilisez le type de champ date pour la date de publication
                        ),
                    buildTextFormField(
                        context, _genreController, 'Genre', Icons.category),
                    buildTextFormField(
                        context, _summaryController, 'Résumé', Icons.subject,
                        maxLines: 3),
                    buildTextFormField(
                        context, _languageController, 'Langue', Icons.language),
                    buildTextFormField(
                        context, _statusController, 'Statut', Icons.info,
                        fieldType: FieldType.dropdown,
                        dropdownItems: statusOptions),
                    buildTextFormField(context, _conditionController,
                        'Condition', Icons.build_circle,
                        fieldType: FieldType.dropdown,
                        dropdownItems: conditionOptions),
                    // Zone de téléchargement d'image
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: _imageBytes != null
                            ? Image.memory(_imageBytes!)
                            : const Icon(Icons.add_a_photo),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _createBook,
                      child: const Text('Créer le livre'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
