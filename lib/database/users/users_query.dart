import 'dart:convert';

import 'package:bibliz/database/database.dart';
import 'package:bibliz/database/users/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
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

  Future<User?> signin(String username, String password) async {
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password)
        .get();
    if (query.docs.isNotEmpty) {
      Map<String, dynamic> user =
          query.docs.first.data() as Map<String, dynamic>;
      return User.fromMap(user);
    } else {
      throw ErrorDescription("Nom d'utilisateur ou mot de passe incorrect");
    }
  }

  Future<void> passwordUpdate(String username, String password) async {
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: username)
        .get()
        .catchError((error) {
      throw error;
    });
    if (query.docs.isNotEmpty) {
      String passwordHash = sha256
          .convert(utf8.encode(password))
          .toString();
      debugPrint(passwordHash);
      await usersCollection.doc(query.docs.first.id).update({'password': passwordHash}).then((value) => debugPrint("Updated"));
    }
  }

  Future<void> usernameUpdate(String username, String newUsername) async {
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: username)
        .get()
        .catchError((error) {
      throw error;
    });
    debugPrint("Avant if:");
    if (query.docs.isNotEmpty) {
      debugPrint("if statement");
      await usersCollection.doc(query.docs.first.id).update({'username': newUsername}).then((value) => debugPrint("Updated"));
    }
  }

  
  Future<Object> getUser() async {
    try {
      var user = [];
      QuerySnapshot<Object?> documents = await usersCollection.get();
      if(documents.docs.isNotEmpty){
        for(var document in documents.docs){
          user.add(User.fromMap(document.data() as Map<String, dynamic>));
        }
      }
      return user;
    } catch (e) {
      return Null;
    }
  }

  Future<Object> getUserRoleWithUserName(String username) async {
    try {
      QuerySnapshot<Object?> documents = await usersCollection.where('username', isEqualTo: username).get();
      if(documents.docs.isNotEmpty){
        return User.fromMap(documents.docs[0].data() as Map<String, dynamic>);
      } else {
        return Null;
      }

    } catch (e) {
      return Null;
    }
  }
}
