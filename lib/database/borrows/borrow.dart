class Borrow {
  final String borrower;
  final String bookIsbn;
  final String bookTitle;
  final DateTime requestDate;
  final String state;
  final DateTime? returnDate;

  Borrow({
    required this.borrower,
    required this.bookTitle,
    required this.bookIsbn,
    required this.requestDate,
    required this.state,
    this.returnDate,
  });
 /*
    Fonction permettant de récupérer un emprunt à partir d'une map
  */
  factory Borrow.fromMap(Map<String, dynamic> map) {
    if (map['returnDate'] == null) {
      return Borrow(
        borrower: map['borrower'],
        bookIsbn: map['bookIsbn'],
        bookTitle: map['bookTitle'],
        requestDate: DateTime.parse(map['requestDate'] as String),
        state: map['state'],
      );
    } else {
      return Borrow(
        borrower: map['borrower'],
        bookIsbn: map['bookIsbn'],
        bookTitle: map['bookTitle'],
        requestDate: DateTime.parse(map['requestDate'] as String),
        state: map['state'],
        returnDate: DateTime.parse(map['returnDate'] as String),
      );
    }
  }

  /*
    Fonction permettant de créer une Map à partir d'un objet Borrow
  */
  Map<String, dynamic> toMap() {
    if (returnDate == null) {
      return {
        'borrower': borrower,
        'bookIsbn': bookIsbn,
        'bookTitle': bookTitle,
        'requestDate': requestDate.toString(),
        'state': state,
      };
    } else {
      return {
        'borrower': borrower,
        'bookIsbn': bookIsbn,
        'requestDate': requestDate.toString(),
        'state': state,
        'returnDate': returnDate.toString()
      };
    }
  }
}
