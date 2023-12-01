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

  Future<bool> passwordUpdate(String username, String oldPassword, String newPassword) async {
    String oldPasswordHash = sha256
        .convert(utf8.encode(oldPassword))
        .toString();
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: oldPasswordHash)
        .get()
        .catchError((error) {
      throw error;
    });
    if (query.docs.isNotEmpty) {
      String newPasswordHash = sha256
          .convert(utf8.encode(newPassword))
          .toString();
      await usersCollection.doc(query.docs.first.id).update({'password': newPasswordHash}).then((value) => debugPrint("Updated"));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> usernameUpdate(String username, String newUsername) async {
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: username)
        .get()
        .catchError((error) {
      throw error;
    });
    if (query.docs.isNotEmpty) {
      debugPrint("if statement");
      var userExist = await getUserRoleWithUserName(newUsername);
      if(userExist == null) {
        debugPrint("final true");
        await usersCollection.doc(query.docs.first.id).update({'username': newUsername}).then((value) => debugPrint("Updated"));
        return true;
      } else {
        debugPrint("final false");
        return false;
      }
    } else {
      debugPrint("false");

      return false;
    }
  }

  
  Future<Object?> getUser() async {
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
      return null;
    }
  }

  Future<Object?> getUserRoleWithUserName(String username) async {
    try {
      QuerySnapshot<Object?> documents = await usersCollection.where('username', isEqualTo: username).get();
      if(documents.docs.isNotEmpty){
        var v = documents.docs.first.data().toString();
        debugPrint('TEST TEST $v');
        return User.fromMap(documents.docs[0].data() as Map<String, dynamic>);
      } else {
        debugPrint('NULL');
        return null;
      }

    } catch (e) {
      return null;
    }
  }
}
