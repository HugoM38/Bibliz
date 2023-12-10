bool validatePassword(String password) {
  final RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');

  return regex.hasMatch(password);
}
