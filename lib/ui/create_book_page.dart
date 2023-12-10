import 'dart:typed_data';

import 'package:bibliz/database/books/book.dart';
import 'package:bibliz/database/books/book_manager.dart';
import 'package:bibliz/database/books/books_query.dart';
import 'package:bibliz/database/database.dart';
import 'package:bibliz/shared/build_app_bar.dart';
import 'package:bibliz/shared/build_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class CreateBookPage extends StatefulWidget {
  const CreateBookPage({super.key});

  @override
  State<CreateBookPage> createState() => _CreateBookPageState();
}

class _CreateBookPageState extends State<CreateBookPage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  Book? newBook;
  List<String> conditionOptions = ['Neuf', 'Bon', 'Usé', 'Endommagé'];
  List<String> bookGenreOptions = [
    'Roman',
    'Fantastique',
    'Science-Fiction',
    'Horreur',
    'Thriller',
    'Policier',
    'Aventure',
    'Romance',
    'Historique',
    'Biographie',
    'Autobiographie',
    'Jeunesse',
    'Enfant',
    'Éducatif',
    'Science',
    'Technologie',
    'Philosophie',
    'Religion',
    'Spiritualité',
    'Art',
    'Musique',
    'Théâtre',
    'Poésie',
    'Cuisine',
    'Voyage',
    'Sport',
    'Santé',
    'Bien-être',
    'Développement personnel',
    'Économie',
    'Politique',
    'Histoire',
    'Sociologie',
    'Psychologie',
    'Écologie',
    'Nature',
    'Animaux',
    'Jardinage',
    'Bricolage',
    'Technique',
    'Informatique',
    'Manga',
    'Bande dessinée',
    'Humour',
    'Érotisme'
  ];
  List<String> languageOptions = [
    'Anglais',
    'Français',
    'Espagnol',
    'Allemand',
    'Italien',
    'Portugais',
    'Russe',
    'Chinois',
    'Japonais',
    'Coréen',
    'Arabe',
    'Hindi',
    'Bengali',
    'Punjabi',
    'Néerlandais',
    'Grec',
    'Polonais',
    'Turc',
    'Suédois',
    'Danois',
    'Norvégien',
    'Finnois',
    'Tchèque',
    'Slovaque',
    'Hongrois',
    'Roumain',
    'Bulgare',
    'Serbe',
    'Croate',
    'Slovène',
    'Lituanien',
    'Letton',
    'Estonien',
    'Islandais',
    'Hébreu',
    'Farsi',
    'Urdu',
    'Swahili',
    'Yoruba',
    'Amharique',
    'Tagalog',
    'Vietnamien',
    'Thaï',
    'Indonésien',
    'Malais'
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _imageExtension;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _publisherController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    _summaryController.dispose();
    _languageController.dispose();
    _conditionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageExtension = path.extension(pickedFile.path);
        });
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erreur lors de la sélection de l'image"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> uploadImage(Uint8List imageBytes, String fileName) async {
    try {

      String fileNameWithExtension = fileName +
          (_imageExtension ??
              '.jpg');

      final ref = Database()
          .firebaseStorage
          .ref()
          .child('images/$fileNameWithExtension');


      final result = await ref.putData(imageBytes);

      return await result.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _createBook() async {
    String? imageUrl;
    if (_imageBytes != null) {
      imageUrl = await uploadImage(_imageBytes!, _isbnController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vous n'avez mis aucune image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_titleController.text.isEmpty ||
        _authorController.text.isEmpty ||
        _isbnController.text.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Veuillez saisir au moins un titre un auteur et un isbn"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
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
      status: 'available',
      condition: _conditionController.text,
      location: _locationController.text,
      imageUrl: imageUrl,
    );

    BooksQuery().addBook(newBook).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Livre ajouté avec succès!'),
          backgroundColor: Colors.green,
        ),
      );
      BookManager().books.add(newBook);
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Créer un nouveau livre",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.45,
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          buildTextFormField(
                              context, _titleController, 'Titre', Icons.book),
                          buildTextFormField(context, _authorController,
                              'Auteur', Icons.person),
                          buildTextFormField(
                              context, _isbnController, 'ISBN', Icons.code),
                          buildTextFormField(context, _publisherController,
                              'Éditeur', Icons.business),
                          buildTextFormField(context, _yearController,
                              'Année de publication', Icons.calendar_today,
                              fieldType: FieldType.date),
                          buildTextFormField(context, _genreController, 'Genre',
                              Icons.category,
                              fieldType: FieldType.dropdown,
                              dropdownItems: bookGenreOptions),
                          buildTextFormField(context, _summaryController,
                              'Résumé', Icons.subject,
                              maxLines: 3),
                          buildTextFormField(
                            context,
                            _languageController,
                            'Langue',
                            Icons.language,
                            fieldType: FieldType.searchableDropdown,
                            dropdownItems: languageOptions,
                            onItemSelected: (selectedValue) {
                              print(selectedValue);
                              setState(() {
                                _languageController.text = selectedValue;
                              });
                            },
                          ),
                          buildTextFormField(context, _conditionController,
                              'Condition', Icons.build_circle,
                              fieldType: FieldType.dropdown,
                              dropdownItems: conditionOptions),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 300,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _imageBytes != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.memory(
                                          _imageBytes!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(Icons.add_a_photo, size: 50),
                              ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
