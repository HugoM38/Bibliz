import 'package:bibliz/database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'book.dart';

class BooksQuery {
  CollectionReference booksCollection =
      Database().firestore.collection('Books');

  /*
    Fonction permettant de créer un livre si il n'existe déjà pas
  */
  Future<void> addBook(Book book) async {
    QuerySnapshot query = await booksCollection
        .where('isbn', isEqualTo: book.isbn)
        .get()
        .catchError((error) {
      throw Exception("Erreur lors de la création du livre");
    });
    if (query.docs.isEmpty) {
      booksCollection.add(book.toMap()).catchError((error) {
        throw Exception("Erreur lors de la création du livre");
      });
    } else {
      throw Exception("Ce livre existe déjà");
    }
  }

  /*
    Fonction permettant de récupérer la liste des livres
  */
  Future<List<Book>> getBooks(int count) async {
    QuerySnapshot query =
        await booksCollection.limit(count).get().catchError((error) {
      throw Exception("Erreur lors de la récupération des livres");
    });
    List<Book> books = [];

    for (var doc in query.docs) {
      Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;
      books.add(Book.fromMap(bookData));
    }

    return books;
  }

  /*
    Fonction permettant de mettre à jour le status d'un livre
  */
  Future<void> changeBookStatus(Book book, String newStatus) async {
    QuerySnapshot query = await booksCollection
        .where('isbn', isEqualTo: book.isbn)
        .get()
        .catchError((error) {
      throw Exception("Erreur lors du changement de status du livre");
    });

    if (query.docs.isNotEmpty) {
      var docId = query.docs.first.id;
      await booksCollection
          .doc(docId)
          .update({'status': newStatus}).catchError((error) {
        throw Exception("Erreur lors du changement de status du livre");
      });
    } else {
      throw ErrorDescription("Livre introuvable");
    }
  }
}
