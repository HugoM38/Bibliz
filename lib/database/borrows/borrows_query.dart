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
          bookTitle: book.title,
          requestDate: DateTime.now(),
          state: "request");
      borrowsCollection.add(borrowRequest.toMap());
    } else {
      throw ErrorDescription("Ce livre n'est pas disponible");
    }
  }

  Future<List<Borrow>> getBorrows() async {
    QuerySnapshot query = await borrowsCollection.get();
    List<Borrow> borrows = [];

    for (var doc in query.docs) {
      Map<String, dynamic> borrowData = doc.data() as Map<String, dynamic>;
      borrows.add(Borrow.fromMap(borrowData));
    }

    return borrows;
  }

  Future<List<Borrow>> getBorrowsByUser(String user) async {
    QuerySnapshot query = await borrowsCollection
        .where('borrower', isEqualTo: user)
        .get();
    List<Borrow> borrows = [];

    for (var doc in query.docs) {
      Map<String, dynamic> borrowData = doc.data() as Map<String, dynamic>;
      borrows.add(Borrow.fromMap(borrowData));
    }

    return borrows;
  }

  Future<void> acceptBorrowRequest(Borrow borrow) async {
    QuerySnapshot query = await borrowsCollection
        .where('bookIsbn', isEqualTo: borrow.bookIsbn)
        .where('requestDate', isEqualTo: borrow.requestDate.toString())
        .get()
        .catchError((error) {
      throw error;
    });

    if (query.docs.isNotEmpty) {
      borrowsCollection.doc(query.docs.first.id).update({
        'returnDate': DateTime.now().add(const Duration(days: 14)).toString(),
        'state': 'accepted'
      }).catchError((error) {
        throw Exception(
            "Une erreur est survenue lors de l'acceptation de l'emprunt");
      });
    }
  }

  Future<void> rejectBorrowRequest(Borrow borrow) async {
    QuerySnapshot query = await borrowsCollection
        .where('bookIsbn', isEqualTo: borrow.bookIsbn)
        .where('requestDate', isEqualTo: borrow.requestDate.toString())
        .get()
        .catchError((error) {
      throw error;
    });

    QuerySnapshot queryBook = await booksCollection
        .where('isbn', isEqualTo: borrow.bookIsbn)
        .get()
        .catchError((error) {
      throw error;
    });

    if (query.docs.isNotEmpty) {
      borrowsCollection
          .doc(query.docs.first.id)
          .update({'state': 'rejected'}).then((_) async {
        await booksCollection
            .doc(queryBook.docs.first.id)
            .update({"status": "unavailable"});
      }).catchError((error) {
        throw Exception("Une erreur est survenue lors du rejet de l'emprunt");
      });
    }
  }

  Future<void> returnBook(Borrow borrow) async {
    QuerySnapshot query = await borrowsCollection
        .where('bookIsbn', isEqualTo: borrow.bookIsbn)
        .where('requestDate', isEqualTo: borrow.requestDate.toString())
        .get()
        .catchError((error) {
      throw error;
    });

    QuerySnapshot queryBook = await booksCollection
        .where('isbn', isEqualTo: borrow.bookIsbn)
        .get()
        .catchError((error) {
      throw error;
    });

    if (query.docs.isNotEmpty) {
      borrowsCollection.doc(query.docs.first.id).update({
        'returnDate': DateTime.now().toString(),
        'state': 'returned'
      }).then((_) async {
        await booksCollection
            .doc(queryBook.docs.first.id)
            .update({"status": "available"});
      }).catchError((error) {
        throw Exception("Une erreur est survenue lors du rendu du livre");
      });
    }
  }
}
