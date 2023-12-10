import 'package:bibliz/database/users/user_roles.dart';
import 'package:bibliz/database/users/users_query.dart';
import 'package:bibliz/shared/build_app_bar.dart';
import 'package:bibliz/ui/widget/search_bar_widget.dart';
import 'package:flutter/material.dart';

import '../../database/users/user.dart';
import '../../shared/build_text_form_field.dart';

class AdministrationPage extends StatefulWidget {
  const AdministrationPage({super.key});

  @override
  State<AdministrationPage> createState() => _AdministrationPageState();
}

class _AdministrationPageState extends State<AdministrationPage> {
  List<User> users = [];
  List<User> filteredUsers = [];
  bool isUsersLoaded = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _filterUsers(String searchText) {
    setState(() {
      filteredUsers = users.where((user) {
        final searchLower = searchText.toLowerCase();
        return user.username.toLowerCase().contains(searchLower);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Libérer le contrôleur de texte
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: buildAppBar(context),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SearchBarWidget(
                                hintText: "Rechercher un utilisateur",
                                searchController: _searchController,
                                onSearchChanged: _filterUsers),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildRowTemplate(
                                  filteredUsers[index], Key(index.toString()));
                            }),
                      ),
                    ],
                  ),
                ))));
  }

  Future<void> _loadUsers() async {
    if (!isUsersLoaded) {
      try {
        List<User> loadedUsers = await UserQuery().getNotAdminUsers();
        setState(() {
          users = loadedUsers;
          filteredUsers = loadedUsers; // Initialisez également filteredBooks
          isUsersLoaded = true;
        });
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget buildRowTemplate(User user, Key key) {
    List<String> roleList = [];

    if (user.role == UserRole.member) {
      roleList = [UserRole.member.name, UserRole.librarian.name];
    } else {
      roleList = [UserRole.librarian.name, UserRole.member.name];
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
                color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          key: key, // Ajout de la clé unique au widget Row
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 75,
                  child: Text(
                    user.username,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.secondary),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: SizedBox(
                width: MediaQuery.of(context).size.width *
                        0.75,
                child: buildTextFormField(
                    context, _conditionController, 'Role', Icons.build_circle,
                    fieldType: FieldType.dropdown, dropdownItems: roleList),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary),
                onPressed: () {
                  if (_conditionController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Erreur lors du changement de rôle"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  UserQuery()
                      .roleUpdate(user.username, _conditionController.text)
                      .then((_) => {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Rôle changé avec succès"),
                                backgroundColor: Colors.green,
                              ),
                            )
                          })
                      .catchError((error) => {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                                backgroundColor: Colors.red,
                              ),
                            )
                          });
                },
                child: Text(
                  'Changer',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
