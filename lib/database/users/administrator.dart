import 'package:bibliz/database/users/user.dart';
import 'package:bibliz/database/users/user_roles.dart';

class Administrator extends User {
  Administrator({
    required String username,
    required String password,
  }) : super(
            username: username,
            password: password,
            role: UserRole.administrator);
}
