import 'package:bibliz/ui/administrator/administrator.dart';
import 'package:bibliz/ui/create_book_page.dart';
import 'package:bibliz/ui/account/signin.dart';
import 'package:bibliz/utils/sharedprefs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Bibliz"),
        actions: [
          ElevatedButton(
              onPressed: () async {
                await SharedPrefs().removeCurrentUser();

                if (context.mounted) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SigninPage()));
                }
              },
              child: const Text("Se déconnecter")),
          ElevatedButton(onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Administrator()
              )
            );
          }, child: const Text("Administration"))
        ],
      ),
      body: const Center(
        child: Text('Bienvenue sur Bibliz!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers la page de création de livre
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateBookPage()),
          );
        },
        tooltip: 'Ajouter un livre',
        child: const Icon(Icons.add),
      ),
    );
  }
}
