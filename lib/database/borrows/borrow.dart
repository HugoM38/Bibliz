class Borrow {
  final String borrower;
  final String bookIsbn;
  final DateTime requestDate;
  final String state;
  final DateTime? returnDate;

  Borrow({
    required this.borrower,
    required this.bookIsbn,
    required this.requestDate,
    required this.state,
    this.returnDate,
  });

  factory Borrow.fromMap(Map<String, dynamic> map) {
    return Borrow(
      borrower: map['borrower'] ?? '',
      bookIsbn: map['bookIsbn'] ?? '',
      requestDate: map['requestDate'] ?? '',
      state: map['state'] ?? '',
      returnDate: map['returnDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'borrower': borrower,
      'bookIsbn': bookIsbn,
      'requestDate': requestDate.toString(),
      'state': state,
      'returnDate': returnDate.toString()
    };
  }
}
