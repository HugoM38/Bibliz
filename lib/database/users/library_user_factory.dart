import 'package:bibliz/database/users/administrator.dart';
import 'package:bibliz/database/users/librarian.dart';
import 'package:bibliz/database/users/member.dart';
import 'package:bibliz/database/users/user.dart';
import 'package:bibliz/database/users/user_factory.dart';
import 'package:bibliz/database/users/user_roles.dart';

/*
    Factory (Design pattern) permettant la création d'utilisateur selon leurs rôles
*/
class LibraryUserFactory implements UserFactory {
  @override
  User createUser(String username, String password, UserRole role) {
    switch (role) {
      case UserRole.member:
        return Member(username: username, password: password);
      case UserRole.librarian:
        return Librarian(username: username, password: password);
      case UserRole.administrator:
        return Administrator(username: username, password: password);
    }
  }
}
