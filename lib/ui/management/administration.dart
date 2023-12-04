import 'package:bibliz/database/users/user_roles.dart';
import 'package:bibliz/database/users/users_query.dart';
import 'package:bibliz/shared/build_app_bar.dart';
import 'package:flutter/material.dart';

import '../../database/users/user.dart';
import '../../shared/build_text_form_field.dart';

GlobalKey<_AdministrationPageState> administrationPageKey = GlobalKey();

class AdministrationPage extends StatefulWidget {
  const AdministrationPage({Key? key}) : super(key: key);


  @override
  _AdministrationPageState createState() => _AdministrationPageState();
}


class _AdministrationPageState extends State<AdministrationPage> {
  List<User> myObjectList = []; // Liste d'objets obtenue depuis Firebase

  List<Widget> dynamicWidgets = []; // Liste dynamique de widgets
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase(); // Appel à la fonction pour récupérer les données depuis Firebase
  }

  @override
  void dispose() {
    _textEditingController.dispose(); // Libérer le contrôleur de texte
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Builder(
        key: administrationPageKey,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                Expanded(
                  child: TextFormField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Entrez du texte',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    debugPrint("HEHPO");
                    replaceList(_textEditingController.text);
                  },
                  child: const Text('Rechercher'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: dynamicWidgets.length,
                itemBuilder: (BuildContext context, int Itemindex){
                  return dynamicWidgets[Itemindex];
                }
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> fetchDataFromFirebase() async {
    myObjectList = await UserQuery().getResearchUserNotAdmin("");
    updateListFromFirebase();
  }

  void updateListFromFirebase() {
    setState(() {
      debugPrint(myObjectList.toString());
      dynamicWidgets.clear();
      debugPrint(myObjectList.toString());
      for (var i = 0; i < myObjectList.length; i++) {
        dynamicWidgets.add(
          buildRowTemplate(myObjectList[i], UniqueKey()), // Utilisation du template de ligne avec le nom de l'objet et une clé unique
        );
      }
    });
    debugPrint(myObjectList.toString());
    if (administrationPageKey.currentState != null) {
      administrationPageKey.currentState!.setState(() {});
    }
  }

  Widget buildRowTemplate(User user, Key key) {
    List<String> roleList = [];

    if(user.toMap()['role'] == "member"){
       roleList = ['member','librarian'];
    } else {
       roleList = ['librarian','member'];
    }
    return Row(
      key: key, // Ajout de la clé unique au widget Row
      children: [
        Text(user.username),
        const SizedBox(width: 10),
        Expanded(
          child: buildTextFormField(context, _conditionController,
            'Role', Icons.build_circle,
            fieldType: FieldType.dropdown,
            dropdownItems: roleList
            ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            UserQuery().roleUpdate(user.username, _conditionController.text);
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
                  (route) => false,
            );
          },
          child: const Text('Changer'),
        ),
      ],
    );
  }

    Future<void> replaceList(String research) async {
    myObjectList = await UserQuery().getResearchUserNotAdmin(research);
    updateListFromFirebase();
  }
}

class MyObject {
  final String name;

  MyObject(this.name);
}
