import 'package:bibliz/database/books/book.dart';

class BookManager {
  static final BookManager _instance = BookManager._internal();

  BookManager._internal();

  factory BookManager() {
    return _instance;
  }

  List<Book> books = [];
  bool isBooksLoaded = false;
}
