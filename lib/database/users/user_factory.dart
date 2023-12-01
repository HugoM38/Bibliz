import 'package:bibliz/database/users/user.dart';
import 'package:bibliz/database/users/user_roles.dart';

abstract class UserFactory {
  User createUser(String username, String password, UserRole role);
}