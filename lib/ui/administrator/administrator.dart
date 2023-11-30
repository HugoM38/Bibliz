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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  List<String> statusOptions = [
    'Disponible',
    'Emprunté',
    'En réparation',
    'Perdu'
  ];
  String? username = SharedPrefs().getCurrentUser();
  final int role = 1;
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le profil')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
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
              onPressed: () {
                showDialog(context: context,
                  builder: (BuildContext context) {
                    String newUsername = _usernameController.text;
                    UserQuery().usernameUpdate(username!, newUsername).then((value) => SharedPrefs().setCurrentUser(newUsername));
                    return AlertDialog(
                      title: Text('Alerte'),
                      content: Text('Votre username a été changé en $newUsername'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage()
                                )
                              );
                          },
                          child: Text('OK'),
                        ),
                      ]);
                    }
                  );
                },child: const Text('Enregistrer nouvel username')
              ),
            const SizedBox(height: 20.0),


            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nouveau mot de passe',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                showDialog(context: context,
                  builder: (BuildContext context) {
                    UserQuery().passwordUpdate(username!, _passwordController.text);
                    return AlertDialog(
                      title: Text('Alerte'),
                      content: Text('Votre mot de passe a bien été changé'),
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
                          child: Text('OK'),
                        ),
                      ],
                    );
                  });
              },
              child: const Text('Enregistrer nouveau mot de passe'),
            ),
            const SizedBox(height: 20.0),
            if(role == 1)
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    buildTextFormField(
                        context, _statusController, 'Biblio', Icons.info,
                        fieldType: FieldType.dropdown,
                        dropdownItems: statusOptions),
                    const SizedBox(height: 20.0)
                  ]
              ),
            if(role == 2)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  buildTextFormField(
                      context, _statusController, 'Admin', Icons.info,
                      fieldType: FieldType.dropdown,
                      dropdownItems: statusOptions),
                  const SizedBox(height: 20.0),
                ]
              )
          ],
        ),
      ),
    );
  }
}