import 'package:bibliz/database/users/user.dart';
import 'package:bibliz/database/users/user_roles.dart';

class Librarian extends User {
  Librarian({
    required String username,
    required String password,
  }) : super(username: username, password: password, role: UserRole.librarian);
}
