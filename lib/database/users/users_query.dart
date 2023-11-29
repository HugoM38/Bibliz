import 'package:bibliz/database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserQuery {
  CollectionReference usersCollection =
      Database().firestore.collection('Users');

  Future<void> signup(String username, String password) async {
    QuerySnapshot query =
        await usersCollection.where('username', isEqualTo: username).get();
    if (query.docs.isEmpty) {
      usersCollection.add({'username': username, 'password': password});
    } else {
      print("erreur");
    }
  }
}
