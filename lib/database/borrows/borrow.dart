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

  factory Borrow.fromMap(Map<String, dynamic> map) {
    return Borrow(
      borrower: map['borrower'],
      bookIsbn: map['bookIsbn'],
      bookTitle: map['bookTitle'],
      requestDate: DateTime.parse(map['requestDate'] as String),
      state: map['state'],
      returnDate: map['returnDate'],
    );
  }

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
