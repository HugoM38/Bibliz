import 'package:bibliz/database/users/users_query.dart';
import 'package:bibliz/shared/validate_password.dart';
import 'package:bibliz/ui/home.dart';
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
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (success) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    }
                  },
                  child: const Text('OK'),
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Bibliz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Modification du profil",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Votre nom d'utilisateur est $username"),
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Nouveau nom d\'utilisateur',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
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
                        content: Text("Veuillez saisir un nom d'utilisateur"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Enregistrer nouvel username')),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Ancien mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nouveau mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_oldPasswordController.text.isNotEmpty &&
                    _newPasswordController.text.isNotEmpty &&
                    validatePassword(_newPasswordController.text)) {
                  UserQuery()
                      .passwordUpdate(username!, _oldPasswordController.text,
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
              child: const Text('Enregistrer nouveau mot de passe'),
            ),
          ],
        ),
      ),
    );
  }
}
