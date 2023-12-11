/*
    Fonction permettant de vérifier que la Regex correspond bien a 1 majuscule, 8 caractères et 1 chiffre
*/
bool validatePassword(String password) {
  final RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');

  return regex.hasMatch(password);
}
