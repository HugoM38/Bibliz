import 'package:bibliz/database/books/book.dart';
import 'package:bibliz/database/books/books_query.dart';
import 'package:bibliz/database/borrows/borrow.dart';
import 'package:bibliz/database/database.dart';
import 'package:bibliz/utils/sharedprefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BorrowsQuery {
  CollectionReference borrowsCollection =
      Database().firestore.collection('Borrows');

  CollectionReference booksCollection =
      Database().firestore.collection('Books');

  Future<void> createBorrowRequest(Book book) async {
    QuerySnapshot query = await booksCollection
        .where('isbn', isEqualTo: book.isbn)
        .get()
        .catchError((error) {
      throw error;
    });

    Book queryBook =
        Book.fromMap(query.docs.first.data() as Map<String, dynamic>);

    if (queryBook.status == "available") {
      BooksQuery().changeBookStatus(book, "unavailable");
      Borrow borrowRequest = Borrow(
          borrower: SharedPrefs().getCurrentUser()!,
          bookIsbn: book.isbn,
          requestDate: DateTime.now(),
          state: "request");
      borrowsCollection.add(borrowRequest.toMap());
    } else {
      throw ErrorDescription("Ce livre n'est pas disponible");
    }
  }
}
