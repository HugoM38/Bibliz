import 'package:bibliz/database/books/books_query.dart';
import 'package:bibliz/database/borrows/borrows_query.dart';
import 'package:flutter/material.dart';
import 'package:bibliz/database/books/book.dart';

class BookDetailModal extends StatelessWidget {
  final Book book;
  final BooksQuery bookQuery = BooksQuery();
  final BorrowsQuery borrowsQuery = BorrowsQuery();

  BookDetailModal({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.15,
          right: MediaQuery.of(context).size.width * 0.15,
          top: MediaQuery.of(context).size.height * 0.10,
          bottom: MediaQuery.of(context).size.height * 0.10),
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(book.title,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary)),
                ),
              ),
              book.imageUrl != null
                  ? Center(
                      child: Container(
                        width: 500,
                        height: 500,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(book.imageUrl!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              _bookDetailRow('Auteur:', book.author, context),
              _bookDetailRow('ISBN:', book.isbn, context),
              _bookDetailRow('Éditeur:', book.publisher, context),
              _bookDetailRow('Année de publication:',
                  book.publicationYear.toString(), context),
              _bookDetailRow('Genre:', book.genre, context),
              _bookDetailRow('Résumé:', book.summary, context),
              _bookDetailRow('Langue:', book.language, context),
              _bookDetailRow('Statut:', book.status, context),
              _bookDetailRow('Condition:', book.condition, context),
              _bookDetailRow('Localisation:', book.location, context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary),
                    child: Text(
                      'Fermer',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary),
                      onPressed: book.status.toLowerCase() == 'available'
                          ? () {
                              borrowsQuery.createBorrowRequest(book).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Demande d'emprunt effectuée avec succès!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
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
                          : null,
                      child: Text(
                        'Emprunter',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookDetailRow(String label, String value, BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            children: <TextSpan>[
              TextSpan(
                  text: label,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: ' $value',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        ),
      ),
    );
  }
}
