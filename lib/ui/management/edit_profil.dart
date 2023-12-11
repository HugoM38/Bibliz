import 'package:bibliz/database/users/users_query.dart';
import 'package:bibliz/shared/build_app_bar.dart';
import 'package:bibliz/shared/validate_password.dart';
import 'package:bibliz/utils/sharedprefs.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();

  String? username = SharedPrefs().getCurrentUser();
  final int role = 0;
  @override
  void dispose() {
    _usernameController.dispose();
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
    super.dispose();
  }
  /*
    Fonction permettant d'afficher une alerte selon les paramètres donnés
  */
  void showAlert(bool success, String type, String? username) {
    String content;
    if (success) {
      if (type == "username") {
        content = "Votre nom d'utilisateur a été changé en $username";
      } else {
        content = 'Votre mot de passe a bien été changé';
      }
    } else {
      if (type == "username") {
        content = "Votre nom d'utilisateur n'a pas été changé en $username";
      } else {
        content =
            "Votre mot de passe n'a pas été changé. Veuillez saisir a nouveau votre ancien mot de passe";
      }
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          SharedPrefs().setCurrentUser(username!);
          return AlertDialog(
              title: success ? const Text('Succès') : const Text('Erreur'),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ]);
        }).then((value) => {
          if (success)
            {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              )
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.80,
            width: MediaQuery.of(context).size.width * 0.40,
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Modification du profil",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "Votre nom d'utilisateur est $username",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            TextFormField(
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              controller: _usernameController,
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.primary,
                                label: const Text("Nouveau nom d'utilisateur"),
                                labelStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary),
                          onPressed: () {
                            String newUsername = _usernameController.text;
                            if (newUsername.isNotEmpty) {
                              UserQuery()
                                  .usernameUpdate(username!, newUsername)
                                  .then((value) async {
                                await SharedPrefs().setCurrentUser(newUsername);
                                showAlert(true, 'username', newUsername);
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                showAlert(false, 'username', newUsername);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Veuillez saisir un nom d'utilisateur"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Modifier',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Divider(
                        indent: 50.0,
                        endIndent: 50.0,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextFormField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      controller: _oldPasswordController,
                      obscureText: true,
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.primary,
                        label: const Text("Ancien mot de passe"),
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextFormField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      controller: _newPasswordController,
                      obscureText: true,
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.primary,
                        label: const Text("Nouveau mot de passe"),
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    onPressed: () {
                      if (_oldPasswordController.text.isNotEmpty &&
                          _newPasswordController.text.isNotEmpty &&
                          validatePassword(_newPasswordController.text)) {
                        UserQuery()
                            .passwordUpdate(
                                username!,
                                _oldPasswordController.text,
                                _newPasswordController.text)
                            .then((value) {
                          showAlert(true, 'password', username);
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                              backgroundColor: Colors.red,
                            ),
                          );
                          showAlert(false, 'password', username);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Veuillez remplir les deux champs de mot de passe qui doit contenir 8 caractères minimum, 1 majuscule et 1 chiffre"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Modifier',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
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
