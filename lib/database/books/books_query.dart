import 'package:bibliz/database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'book.dart';

class BookQuery {
  CollectionReference booksCollection =
      Database().firestore.collection('Books');

  Future<void> addBook(Book book) async {
    QuerySnapshot query = await booksCollection
        .where('isbn', isEqualTo: book.isbn)
        .get()
        .catchError((error) {
      throw error;
    });
    if (query.docs.isEmpty) {
      booksCollection.add(book.toMap());
    } else {
      throw ErrorDescription("Ce livre existe déjà");
    }
  }

  Future<List<Book>> getBooks(int count) async {
    QuerySnapshot query = await booksCollection.limit(count).get();
    List<Book> books = [];

    for (var doc in query.docs) {
      Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;
      books.add(Book.fromMap(bookData));
    }

    return books;
  }

   Future<void> changeBookStatus(Book book, String newStatus) async {
    QuerySnapshot query = await booksCollection
        .where('isbn', isEqualTo: book.isbn)
        .get()
        .catchError((error) {
      throw error;
    });

    if (query.docs.isNotEmpty) {
      var docId = query.docs.first.id;
      await booksCollection.doc(docId).update({'status': newStatus})
          .catchError((error) {
        throw error;
      });
    } else {
      throw ErrorDescription("Livre introuvable");
    }
  }
}
