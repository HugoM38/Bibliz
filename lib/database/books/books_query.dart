import 'package:bibliz/database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'book.dart';

class BookQuery {
  CollectionReference booksCollection =
      Database().firestore.collection('Books');

  Future<void> addBook(Book book) async {
    QuerySnapshot query =
        await booksCollection.where('isbn', isEqualTo: book.isbn).get().catchError((error) {
      throw error;
    });
    if (query.docs.isEmpty) {
      booksCollection.add(book.toMap());
    } else {
       throw ErrorDescription("Ce livre existe déjà");
    }
  }
}
