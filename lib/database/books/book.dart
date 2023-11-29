class Book {
  final String title;
  final String author;
  final String isbn;
  final String publisher;
  final int publicationYear;
  final String genre;
  final String summary;
  final String language;
  final String status;
  final String condition;
  final String location;

  Book({
    required this.title,
    required this.author,
    required this.isbn,
    required this.publisher,
    required this.publicationYear,
    required this.genre,
    required this.summary,
    required this.language,
    required this.status,
    required this.condition,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'isbn': isbn,
      'publisher': publisher,
      'publicationYear': publicationYear,
      'genre': genre,
      'summary': summary,
      'language': language,
      'status': status,
      'condition': condition,
      'location': location,
    };
  }
}
