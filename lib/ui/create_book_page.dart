import 'package:bibliz/database/books/book.dart';
import 'package:bibliz/database/books/books_query.dart';
import 'package:bibliz/shared/build_text_form_field.dart';
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
  XFile? _imageFile;
  Book? newBook;

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
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      // Gérer l'erreur
    }
  }

  void _createBook() {
    print("Créer le livre cliqué"); // Ajoutez cette ligne pour tester
    // Création de l'objet Book avec les valeurs des contrôleurs
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
    );
    // Utilisez BookQuery pour enregistrer le livre
    BookQuery().addBook(newBook).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Livre ajouté avec succès!'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      print('Erreur lors de l\'ajout du livre: $error'); // Ajoutez cette ligne
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
        title: const Text('Créer un nouveau livre'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                buildTextFormField(_titleController, 'Titre', Icons.book),
                buildTextFormField(_authorController, 'Auteur', Icons.person),
                buildTextFormField(_isbnController, 'ISBN', Icons.code),
                buildTextFormField(
                    _publisherController, 'Éditeur', Icons.business),
                buildTextFormField(_yearController, 'Année de publication',
                    Icons.calendar_today,
                    isNumber: true),
                buildTextFormField(_genreController, 'Genre', Icons.category),
                buildTextFormField(_summaryController, 'Résumé', Icons.subject,
                    maxLines: 3),
                buildTextFormField(
                    _languageController, 'Langue', Icons.language),
                buildTextFormField(_statusController, 'Statut', Icons.info),
                buildTextFormField(
                    _conditionController, 'Condition', Icons.build_circle),
                buildTextFormField(
                    _locationController, 'Localisation', Icons.place),
                // Zone de téléchargement d'image
                GestureDetector(
                  onTap: () {}, // Logique pour choisir une image
                  child: Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: _imageFile != null
                        ? Image.file(File(_imageFile!.path))
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
      ),
    );
  }
}
