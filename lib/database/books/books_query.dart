import 'package:bibliz/database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'book.dart';

class BookQuery {
  CollectionReference booksCollection =
      Database().firestore.collection('Books');

  Future<void> addBook(Book book) async {
    QuerySnapshot query =
        await booksCollection.where('isbn', isEqualTo: book.isbn).get();
    if (query.docs.isEmpty) {
      booksCollection.add(book.toMap());
    } else {
      print("Book already exists");
    }
  }
}
