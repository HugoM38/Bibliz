import 'package:bibliz/database/database.dart';
import 'package:bibliz/database/users/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserQuery {
  CollectionReference usersCollection =
      Database().firestore.collection('Users');

  Future<void> signup(User user) async {
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: user.username)
        .get()
        .catchError((error) {
      throw error;
    });
    if (query.docs.isEmpty) {
      usersCollection.add(user.toMap());
    } else {
      throw ErrorDescription("Il existe déjà un utilisateur avec ce nom");
    }
  }
}
