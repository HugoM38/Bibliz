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

  Future<Book?> getBookByTitle(String title) async {
    QuerySnapshot query =
        await booksCollection.where('title', isEqualTo: title).get();
    if (query.docs.isNotEmpty) {
      Map<String, dynamic> book =
          query.docs.first.data() as Map<String, dynamic>;
      return Book.fromMap(book);
    } else {
      throw ErrorDescription("Ce livre n'existe pas");
    }
  }
}
