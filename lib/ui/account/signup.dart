import 'dart:convert';

import 'package:bibliz/database/users/library_user_factory.dart';
import 'package:bibliz/database/users/user.dart';
import 'package:bibliz/database/users/user_roles.dart';
import 'package:bibliz/database/users/users_query.dart';
import 'package:bibliz/shared/build_app_bar.dart';
import 'package:bibliz/shared/validate_password.dart';
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width * 0.40,
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Inscription",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      controller: _usernameController,
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.primary,
                        label: const Text("Nom d'utilisateur"),
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.primary,
                        label: const Text("Mot de passe"),
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
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
                          await SharedPrefs()
                              .setCurrentUserRole(UserRole.member);
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (route) => false,
                            );
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
                      child: Text(
                        'Inscription',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
