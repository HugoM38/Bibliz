import 'package:bibliz/database/users/user.dart';
import 'package:bibliz/database/users/user_roles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final String _userKey = 'currentUser';
  final String _userRoleKey = 'currentUserRole';
  late SharedPreferences prefs;

  SharedPrefs._privateConstructor();

  static final SharedPrefs _instance = SharedPrefs._privateConstructor();

  factory SharedPrefs() {
    return _instance;
  }

  initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  String? getCurrentUser() {
    return prefs.getString(_userKey);
  }

  UserRole? getCurrentUserRole() {
    return User.parseUserRole(prefs.getString(_userRoleKey)!);
  }

  Future<void> setCurrentUser(String value) async {
    await prefs.setString(_userKey, value);
  }

  Future<void> setCurrentUserRole(UserRole value) async {
    await prefs.setString(_userRoleKey, value.name);
  }

  Future<void> removeCurrentUser() async {
    await prefs.remove(_userRoleKey);
    await prefs.remove(_userKey);
  }
}
