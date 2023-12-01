import 'package:flutter/material.dart';
import 'package:bibliz/database/books/book.dart'; // Importez votre modèle de livre

class BookDetailModal extends StatelessWidget {
  final Book book;

  const BookDetailModal({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Dialog(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(book.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _bookDetailRow('Auteur:', book.author),
              _bookDetailRow('ISBN:', book.isbn),
              _bookDetailRow('Éditeur:', book.publisher),
              _bookDetailRow(
                  'Année de publication:', book.publicationYear.toString()),
              _bookDetailRow('Genre:', book.genre),
              _bookDetailRow('Résumé:', book.summary),
              _bookDetailRow('Langue:', book.language),
              _bookDetailRow('Statut:', book.status),
              _bookDetailRow('Condition:', book.condition),
              _bookDetailRow('Localisation:', book.location),
              book.imageUrl != null
                  ? Image.network(book.imageUrl!)
                  : SizedBox(),
              SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Fermer'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(
                text: label, style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' $value'),
          ],
        ),
      ),
    );
  }
}
