import 'package:bibliz/database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserQuery {
  CollectionReference usersCollection =
      Database().firestore.collection('Users');

  Future<void> signup(String username, String password) async {
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: username)
        .get()
        .catchError((error) {
      throw error;
    });
    if (query.docs.isEmpty) {
      usersCollection.add({'username': username, 'password': password});
    } else {
      throw ErrorDescription("Il existe déjà un utilisateur avec ce nom");
    }
  }
}
