import 'package:bibliz/database/users/user_roles.dart';

class User {
  final String username;
  final String password;
  final UserRole role;
  User({
    required this.username,
    required this.password,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
      role: parseUserRole(map['role']),
    );
  }

  static UserRole parseUserRole(String roleString) {
    switch (roleString.toLowerCase()) {
      case 'member':
        return UserRole.member;
      case 'librarian':
        return UserRole.librarian;
      case 'administrator':
        return UserRole.administrator;
      default:
        throw UserRole.member;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'role': role.name,
    };
  }
}
