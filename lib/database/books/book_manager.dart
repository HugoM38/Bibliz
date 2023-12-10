import 'package:bibliz/database/books/book.dart';

class BookManager {
  static final BookManager _instance = BookManager._internal();

  BookManager._internal();

  factory BookManager() {
    return _instance;
  }

  List<Book> books = [];
  bool isBooksLoaded = false;

  void updateStatusBookList(Book book, bool available) {
    int index = books.indexOf(book);

    Book updatedBook = Book(
        title: book.title,
        author: book.author,
        isbn: book.isbn,
        publisher: book.publisher,
        publicationYear: book.publicationYear,
        genre: book.genre,
        summary: book.summary,
        language: book.language,
        status: available ? "available" : "unavailable",
        condition: book.condition,
        location: book.location,
        imageUrl: book.imageUrl);

    books[index] = updatedBook;
  }
}
