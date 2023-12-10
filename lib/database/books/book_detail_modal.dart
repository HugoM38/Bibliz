import 'package:bibliz/database/books/books_query.dart';
import 'package:bibliz/database/borrows/borrows_query.dart';
import 'package:flutter/material.dart';
import 'package:bibliz/database/books/book.dart'; // Importez votre modèle de livre

class BookDetailModal extends StatelessWidget {
  final Book book;
  final BooksQuery bookQuery = BooksQuery();
  final BorrowsQuery borrowsQuery = BorrowsQuery();

  BookDetailModal({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Dialog(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(book.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
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
                  : const SizedBox(),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Fermer'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: book.status.toLowerCase() == 'available'
                      ? () {
                          borrowsQuery.createBorrowRequest(book).then((_) {
                            // Afficher un message de succès
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Demande d'emprunt effectuée avec succès!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(
                                context); // Ferme le dialogue ou la carte
                          }).catchError((error) {
                            // Afficher un message d'erreur
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                        }
                      : null,
                  child: const Text('Emprunter'),
                ),
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
          style: const TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(
                text: label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' $value'),
          ],
        ),
      ),
    );
  }
}
