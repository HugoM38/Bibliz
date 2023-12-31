import 'dart:convert';

import 'package:bibliz/database/database.dart';
import 'package:bibliz/database/users/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class UserQuery {
  CollectionReference usersCollection =
      Database().firestore.collection('Users');

  /*
    Fonction permettant d'ajouter un utilisateur à la base de données si il n'existe pas
  */
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

  /*
    Fonction permettant de se connecter
  */
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

  /*
    Fonction permettant de mettre à jour un mot de passe
  */
  Future<void> passwordUpdate(
      String username, String oldPassword, String newPassword) async {
    String oldPasswordHash =
        sha256.convert(utf8.encode(oldPassword)).toString();
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: oldPasswordHash)
        .get()
        .catchError((error) {
      throw Exception(
          "Une erreur est survenue lors du changement de mot de passe");
    });
    if (query.docs.isNotEmpty) {
      String newPasswordHash =
          sha256.convert(utf8.encode(newPassword)).toString();
      usersCollection
          .doc(query.docs.first.id)
          .update({'password': newPasswordHash}).catchError((error) {
        throw Exception(
            "Une erreur est survenue lors du changement de mot de passe");
      });
    } else {
      throw Exception(
          "Une erreur est survenue lors du changement de mot de passe");
    }
  }

  /*
    Fonction permettant de mettre à jour le rôle d'un utilisateur
  */
  Future<void> roleUpdate(String username, String role) async {
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: username)
        .get()
        .catchError((error) {
      throw Exception("Une erreur est survenue lors du changement de rôle");
    });
    if (query.docs.isNotEmpty) {
      usersCollection
          .doc(query.docs.first.id)
          .update({'role': role}).catchError((error) {
        throw Exception("Une erreur est survenue lors du changement de rôle");
      });
    } else {
      throw Exception("Une erreur est survenue lors du changement de rôle");
    }
  }

  /*
    Fonction permettant de mettre à jour le nom d'utilisateur d'un utilisateur
  */
  Future<void> usernameUpdate(String username, String newUsername) async {
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: username)
        .get()
        .catchError((error) {
      throw Exception(
          "Une erreur est survenue lors du changement de nom d'utilisateur");
    });

    QuerySnapshot queryNewUsername = await usersCollection
        .where('username', isEqualTo: newUsername)
        .get()
        .catchError((error) {
      throw Exception(
          "Une erreur est survenue lors du changement de nom d'utilisateur");
    });
    if (query.docs.isNotEmpty && queryNewUsername.docs.isEmpty) {
      await usersCollection
          .doc(query.docs.first.id)
          .update({'username': newUsername}).catchError((error) {
        throw Exception(
            "Une erreur est survenue lors du changement de nom d'utilisateur");
      });
    } else {
      throw Exception(
          "Une erreur est survenue lors du changement de nom d'utilisateur");
    }
  }

  /*
    Fonction permettant de récupérer la liste des utilisateurs
  */
  Future<List<User>> getUsers() async {
    List<User> users = [];
    QuerySnapshot documents = await usersCollection.get();
    if (documents.docs.isNotEmpty) {
      if (documents.docs.isNotEmpty) {
        for (var document in documents.docs) {
          users.add(User.fromMap(document.data() as Map<String, dynamic>));
        }
      } else {
        throw Exception("Aucun utilisateurs trouvé");
      }
      return users;
    } else {
      return users;
    }
  }

  /*
    Fonction permettant de récupérer la liste des utilisateurs non admin
  */
  Future<List<User>> getNotAdminUsers() async {
    List<User> users = [];
    QuerySnapshot documents;

    documents = await usersCollection
        .where('role', isNotEqualTo: 'administrator')
        .get().catchError((error) {
          throw Exception("Erreur lors de la récupération de utilisateurs");
        });

    if (documents.docs.isNotEmpty) {
      for (var document in documents.docs) {
        users.add(User.fromMap(document.data() as Map<String, dynamic>));
      }
    } else {
      throw Exception("Erreur lors de la récupération de utilisateurs");
    }
    return users;
  }
}
