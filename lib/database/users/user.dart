class User {
  final String username;
  final String password;
  final List<dynamic> roles;
  User({
    required this.username,
    required this.password,
    required this.roles,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
      roles: map['roles'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'roles': roles,
    };
  }
}
