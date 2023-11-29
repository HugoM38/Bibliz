class User {
  final String username;
  final String password;
  final List<String> role;
  User({
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'role': role,
    };
  }
}
