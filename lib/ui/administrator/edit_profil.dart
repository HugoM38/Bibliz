import 'package:bibliz/database/users/users_query.dart';
import 'package:bibliz/ui/home.dart';
import 'package:bibliz/utils/sharedprefs.dart';
import 'package:flutter/material.dart';

import '../../shared/build_text_form_field.dart';

class Administrator extends StatelessWidget {
  const Administrator({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  List<String> statusOptions = [
    'Disponible',
    'Emprunté',
    'En réparation',
    'Perdu'
  ];
  String? username = SharedPrefs().getCurrentUser();
  final int role = 0;
  @override
  void dispose() {
    _usernameController.dispose();
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le profil')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RichText(text: TextSpan(
              text: "Votre username actuel est $username"
            )),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Nouveau nom d\'utilisateur',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                String newUsername = _usernameController.text;
                bool done = false;
                await UserQuery().usernameUpdate(username!, newUsername).then((value) => done = value);
                if(context.mounted) {
                  showDialog(context: context,
                      builder: (BuildContext context) {
                        if (done) {
                          SharedPrefs().setCurrentUser(newUsername);
                          return AlertDialog(
                              title: const Text('Alerte'),
                              content: Text(
                                  'Votre username a été changé en $newUsername'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                            builder: (
                                                context) => const HomePage()
                                        )
                                    );
                                  },
                                  child: const Text('OK'),
                                ),
                              ]);
                        } else {
                          return AlertDialog(
                              title: const Text('Alerte'),
                              content: Text(
                                  'Votre username n\'a pas été changé en $newUsername'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ]);
                        }
                      }

                  );
                }
                },child: const Text('Enregistrer nouvel username')
              ),
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
              onPressed: () async {
                bool done = await UserQuery().passwordUpdate(username!, _oldPasswordController.text, _newPasswordController.text);
                if(context.mounted){
                  showDialog(context: context,
                    builder: (BuildContext context) {
                      if(done){
                        return AlertDialog(
                          title: const Text('Alerte'),
                          content: const Text('Votre mot de passe a bien été changé'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HomePage()
                                    )
                                );
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      } else {
                        return AlertDialog(
                          title: const Text('Alerte'),
                          content: const Text('Votre mot de passe n\'a pas été changé. Veuillez resaisir votre ancien mot de passe'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      }
                  });
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