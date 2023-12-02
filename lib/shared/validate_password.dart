bool validatePassword(String password) {
  // La regex pour un mot de passe avec au moins 8 caractères, une majuscule et un chiffre
  final RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');

  return regex.hasMatch(password);
}
