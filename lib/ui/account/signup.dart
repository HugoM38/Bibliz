import 'dart:convert';

import 'package:bibliz/database/users/library_user_factory.dart';
import 'package:bibliz/database/users/user.dart';
import 'package:bibliz/database/users/user_roles.dart';
import 'package:bibliz/database/users/users_query.dart';
import 'package:bibliz/shared/build_app_bar.dart';
import 'package:bibliz/utils/sharedprefs.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Inscription",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: _usernameController,
                    decoration:
                      const InputDecoration(labelText: "Nom d'utilisateur"),
                  ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                  ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    String username = _usernameController.text;
                    if (!validatePassword(_passwordController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Il faut un mot de passe avec 8 caractères minimum, un chiffre et une majuscule"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      return;
                    }

                    String password = sha256
                        .convert(utf8.encode(_passwordController.text))
                        .toString();

                    User user = LibraryUserFactory()
                        .createUser(username, password, UserRole.member);

                    UserQuery().signup(user).then((value) async {
                      await SharedPrefs().setCurrentUser(username);
                      await SharedPrefs().setCurrentUserRole(UserRole.member);
                      if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/home');
                      }
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    });
                  },
                  child: const Text('Inscription'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  bool validatePassword(String password) {
    // La regex pour un mot de passe avec au moins 8 caractères, une majuscule et un chiffre
    final RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');

    return regex.hasMatch(password);
  }
}
