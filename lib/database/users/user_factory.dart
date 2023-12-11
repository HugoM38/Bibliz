import 'package:bibliz/database/users/user.dart';
import 'package:bibliz/database/users/user_roles.dart';

/*
    Factory (Design pattern) permettant la création d'utilisateur selon leurs rôles
*/
abstract class UserFactory {
  User createUser(String username, String password, UserRole role);
}